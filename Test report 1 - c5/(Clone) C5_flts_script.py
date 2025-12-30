#%python
#%pip install xlsxwriter
mode='PROD'

import os
import pandas as pd
import logging
import datetime
from email.header import Header
from email.utils import formataddr
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
import smtplib as smtp
import psycopg2
import xlsxwriter

REPORT_DT = datetime.datetime.today() - datetime.timedelta(days=1)

Query = '/Workspace/Ops Analysis/Reports/C5 Report/C5_Flights.sql'
Query2= '/Workspace/Ops Analysis/Reports/C5 Report/Metrics.sql'

Excel1='/Workspace/Ops Analysis/Reports/C5 Report/C5_Flights.xlsx'
Excel2='/Workspace/Ops Analysis/Reports/C5 Report/Metrics_Template.xlsx'

################## UDH User credentials setup ########################
cred = pd.read_csv('/Workspace/Ops Analysis/Reports/Login Credentials/Daily_Ops_Call.csv')
user = cred['user'][0]
pasw = cred['pass'][0]

conn = psycopg2.connect(user=user,
                        password=pasw,
                        host='cbs-udh-datalake-prod-redshift-dw1.csjkuisl0oi7.us-east-1.redshift.amazonaws.com',
                        dbname='udhprod',
                        port=5439)
cursor = conn.cursor()

########### open 1st sql file and store data ###########
e = open(Query, 'r')
sqlEdw1 = e.read()
sqlEdw1 = sqlEdw1.replace(':DATE:', REPORT_DT.strftime('%Y-%m-%d'))
e.close()
dfEdw1 = pd.read_sql_query(sqlEdw1, conn)

dfEdw1['act_dprt_dtml'] = pd.to_datetime(dfEdw1['act_dprt_dtml'], errors='coerce')
dfEdw1['act_arrv_dtml'] = pd.to_datetime(dfEdw1['act_arrv_dtml'], errors='coerce')

########### open 2nd sql file and store data ###########
e2 = open(Query2, 'r')
sqlEdw2 = e2.read()
sqlEdw2 = sqlEdw2.replace(':DATE:', REPORT_DT.strftime('%Y-%m-%d'))
e2.close()
dfEdw2 = pd.read_sql_query(sqlEdw2, conn)
conn.close()

########### All flights excel ####################

writer = pd.ExcelWriter(Excel1, engine="xlsxwriter")
dfEdw1.to_excel(writer, startrow=1, header=True, index=False)

workbook = writer.book
worksheet = writer.sheets['Sheet1']
header='C5 All Flights: ' + (REPORT_DT.strftime('%Y-%m-%d'))

merge_format=workbook.add_format({'bold': True, 'font_color': 'black','bg_color':'#AEAAAA','font_size':20})
merge_format.set_align('center')
worksheet.merge_range('A1:U1',header,merge_format)

worksheet.set_column(0,20,20)

writer.close()

########### C5 Metrics excel ####################
writer2 = pd.ExcelWriter(Excel2, engine="xlsxwriter")
dfEdw2.to_excel(writer2, startrow=1, header=True, index=False)
dfEdw2.fillna('-', inplace=True)

workbook = writer2.book
worksheet = writer2.sheets['Sheet1']


cell_format = workbook.add_format({'bold': True, 'font_color': 'white','bg_color':'#4472C4','font_size':12})
cell_format.set_align('center')
worksheet.write('A2','Station',cell_format)
worksheet.write('B2','Timeframe',cell_format)
worksheet.write('C2','Metric',cell_format)
worksheet.write('D2','UAX',cell_format)
worksheet.write('E2','AAX',cell_format)
worksheet.write('F2','DLX',cell_format)
worksheet.write('G2','ASX',cell_format)
worksheet.write('H2','C5',cell_format)
worksheet.write('I2','G7',cell_format)
worksheet.write('J2','OO',cell_format)
worksheet.write('K2','YV',cell_format)
worksheet.write('L2','YX',cell_format)
worksheet.write('M2','ZW',cell_format)

percent_fmt = workbook.add_format({'num_format': '0.00%'})
worksheet.set_column('A:C',20)
worksheet.set_column('D3:M1000',20,percent_fmt)

header='Operational Status as of: ' + (REPORT_DT.strftime('%Y-%m-%d'))
merge_format=workbook.add_format({'bold': True, 'font_color': 'black','bg_color':'#AEAAAA','font_size':20})
merge_format.set_align('center')
worksheet.merge_range('A1:M1',header,merge_format)

writer2.close()

############################ Send Email ###################################

server = smtp.SMTP('mailout.ual.com:25')
emailFrom = 'OpsAnalysis-IKC@united.com'
emailFromHdr = formataddr((str(Header(r'OpsAnalysis-IKC')), emailFrom))

# Distribution list
if mode == 'TEST':
    listEmailTo = ['opsanalysis-ikc@united.com']
    listEmailCc = ['opsanalysis-ikc@united.com']
    listEmailBcc = ['opsanalysis-ikc@united.com']
else:
    listEmailTo = ['teamsite@commutair.com', 'flightdata@commutair.com', 'Amita.kale@commutair.com', 'c5IT@commutair.com', 'OpsAnalysis-IKC@united.com']
    listEmailCc = ['NOC-GRP-GGN@united.com', 'pat.oldfield@united.com']
    listEmailBcc = ['prashant.agarwal@united.com', 'harsh.gautam@united.com']

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart()
msg['From'] = emailFromHdr
msg['To'] = ','.join(listEmailTo)
msg['Cc'] = ','.join(listEmailCc)
msg['Bcc'] = ','.join(listEmailBcc)
msg['Subject'] = "C5 Daily Flights and UAX Operational Snapshot- " + REPORT_DT.strftime('%Y-%m-%d')

htmlBdy = """<html>
            <head></head>
            <body>
            <p><b>*** This is an automated email ***</b>
            <br>
            <br>Hi,
            <br>
            <br>Please find attached the daily CommutAir flights list and UAX operational snapshot.
            <br>
            <br>Thanks,
            <br><font size="3">Ops Analysis
            </body>
            </html>"""

xlsx = open(Excel1, 'rb').read()
msgXlsx1 = MIMEApplication(xlsx, 'xlsx')
msgXlsx1.add_header('Content-ID', '<xlsx1>')
msgXlsx1.add_header('Content-Disposition', 'attachment', filename=r'C5_Flights ' + REPORT_DT.strftime('%Y-%m-%d') + '.xlsx')
msgXlsx1.add_header('Content-Disposition', 'inline', filename=r'C5_Flights ' + REPORT_DT.strftime('%Y-%m-%d') + '.xlsx')


xlsx = open(Excel2, 'rb').read()
msgXlsx2 = MIMEApplication(xlsx, 'xlsx')
msgXlsx2.add_header('Content-ID', '<xlsx1>')
msgXlsx2.add_header('Content-Disposition', 'attachment', filename=r'Operational Snapshot '+ REPORT_DT.strftime('%Y-%m-%d') + '.xlsx')
msgXlsx2.add_header('Content-Disposition', 'inline', filename=r'Operational Snapshot '+ REPORT_DT.strftime('%Y-%m-%d') + '.xlsx')

body = MIMEText(htmlBdy, 'html')
msg.attach(body)
msg.attach(msgXlsx1)
msg.attach(msgXlsx2)
server.sendmail(emailFrom, listEmailTo + listEmailCc + listEmailBcc, msg.as_string())

server.quit()
print('Email Sent')
logging.info('Email Sent')

