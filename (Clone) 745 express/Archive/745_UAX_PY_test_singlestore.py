# -*- coding: utf-8 -*-
"""
Created on Thu Jan 30 09:39:45 2020

@author: u346552
"""



import pandas as pd
import datetime
import logging
import os
import pyodbc
import time
from smtplib import SMTP
import smtplib as smtp
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import win32com.client
from email.utils import formataddr
from email.header import Header
from email import encoders
from email.mime.base import MIMEBase
from email.mime.application import MIMEApplication
from email.mime.image import MIMEImage
import urllib.parse
from sqlalchemy import create_engine, text
from O365 import*
import re
from random import *

os.chdir(r'D:\Users\Nikita\Py\745_UAX_Report\Changes_Apoorva')
TODAY = datetime.datetime.today().strftime('%Y%m%d')
YES = datetime.date.today() - datetime.timedelta(days=1)
YESTERDAY = YES.strftime('%m/%d/%Y')
YEST = YES.strftime('%Y-%m-%d')


LOG_FILE_NAME = os.getcwd() + r'/logs/' + datetime.datetime.today().strftime('%Y%m%d %H%M%S') + '.log'
CSV_FLDR = os.getcwd() + r'/CSV/'
SQL_FOLDER = os.getcwd() + r'/SQL'
XLSX_FLDR = os.getcwd() + r'/XLSX/'
HTML_FLDR = os.getcwd() + r'/HTML/'
PNG_FLDR = os.getcwd() + r'/DailyImages/'
filename_attach = os.getcwd() + r'/0745_UAX_WB_Flights.xlsm'
PDF_FLDR = os.getcwd() + r'/PDF/'
EMAIL_ADDR_FILE = os.getcwd() + r'/emailAddr.csv'
EMAIL_ADDR_FILE_TEST = os.getcwd() + r'/emailAddr_test.csv'

filename = os.getcwd() + r'/0745_UAX_WB.xlsm'

CID1 =  '1'
CID2 =  '2'

HTML_BDY_FILE_PATH = HTML_FLDR + r'EmailBody.htm'
HTML_FTR_FILE_PATH = HTML_FLDR + r'EmailFooter.htm'


XLS_FILE_PATH = XLSX_FLDR + YEST + r' 0745 UAX Flight details.xlsm'

XLS_FILE_NAME = YEST + r' 0745 UAX Flight details.xlsm'

EDW_SQL_1= SQL_FOLDER + r'/UA_SQL_1.sql'
EDW_SQL_2= SQL_FOLDER +r'/CNXL_SQL_2.sql'
EDW_SQL_3= SQL_FOLDER +r'/RES_CNXL_SQL_3.sql'
EDW_SQL_4= SQL_FOLDER +r'/SCH_DEP_SQL_4.sql'
EDW_SQL_5= SQL_FOLDER +r'/DIVERTS_SQL_5.sql'
EDW_SQL_6= SQL_FOLDER +r'/RECOVERED_DIVERTS_SQL_6.sql'
EDW_SQL_7= SQL_FOLDER +r'/UA_HUB_SQL_7.sql'
EDW_SQL_8= SQL_FOLDER +r'/FLIGHTS_NOT_DEPARTED_SQL_8.sql'

EDW_SQL_9= SQL_FOLDER +r'/Cancelled_flights_SQL_9.sql'
EDW_SQL_10= SQL_FOLDER +r'/Yet_to_Depart_flights_SQL_10.sql'
EDW_SQL_11= SQL_FOLDER +r'/Residual_cancels_SQL_11.sql'
EDW_SQL_12= SQL_FOLDER +r'/REPOSITIONED_FLIGHTS_SQL_12.sql'

EDW_SQL_13= SQL_FOLDER +r'/REPOSITIONED_FLIGHTS_COUNT_SQL_13.sql'
EDW_SQL_14= SQL_FOLDER +r'/Diverted_flights_SQL_14.sql'
DELAYS_SQL= SQL_FOLDER +r'/Delay_Info_upd 2.sql'
UA_2019 = SQL_FOLDER + r'/UA_SQL_1_2019.sql'
DIVERTS_2019 = SQL_FOLDER + r'/DIVERTS_SQL_5_2019.sql'
RECOVERED_2019 = SQL_FOLDER + r'/RECOVERED_DIVERTS_2019.sql'
EDW_SQL_15 = SQL_FOLDER + r'/UA_L7D.sql'
EDW_SQL_16 = SQL_FOLDER + r'/UA_Line.sql'

MF_SQL_1= SQL_FOLDER +r'/OA_SQL_1.sql'
MF_SQL_2= SQL_FOLDER +r'/OA_SQL_2.sql'
MF_SQL_3= SQL_FOLDER +r'/OA_Line.sql'

UA_SQL_1_CSV_FILE = CSV_FLDR + r'UA_SQL_1_' +TODAY+'.csv'
CNXL_SQL_2_CSV_FILE = CSV_FLDR + r'CNXL_SQL_2_' +TODAY+'.csv'
RES_CNXL_SQL_3_CSV_FILE = CSV_FLDR + r'RES_CNXL_SQL_3_' +TODAY+'.csv'
SCH_DEP_SQL_4_CSV_FILE = CSV_FLDR + r'SCH_DEP_SQL_4_' +TODAY+'.csv'
DIVERTS_SQL_5_CSV_FILE = CSV_FLDR + r'DIVERTS_SQL_5_' +TODAY+'.csv'
RECOVERED_DIVERTS_SQL_6_CSV_FILE = CSV_FLDR + r'RECOVERED_DIVERTS_SQL_6_' +TODAY+'.csv'
UA_HUB_SQL_7_CSV_FILE = CSV_FLDR + r'UA_HUB_SQL_7_' +TODAY+'.csv'
FLIGHTS_NOT_DEPARTED_SQL_8_CSV_FILE = CSV_FLDR + r'FLIGHTS_NOT_DEPARTED_SQL_8_' +TODAY+'.csv'
REPOSITIONED_FLIGHTS_COUNT_SQL_13_CSV_FILE = CSV_FLDR + r'REPOSITIONED_FLIGHTS_COUNT_SQL_13_' +TODAY+'.csv'

Cancelled_flights_SQL_9_CSV_FILE = CSV_FLDR + r'Cancelled_flights_SQL_9_' +TODAY+'.csv'
Yet_to_Depart_flights_SQL_10_CSV_FILE = CSV_FLDR + r'Yet_to_Depart_flights_SQL_10_' +TODAY+'.csv'
Residual_cancels_SQL_11_CSV_FILE = CSV_FLDR + r'Residual_cancels_SQL_11_' +TODAY+'.csv'
REPOSITIONED_FLIGHTS_SQL_12_CSV_FILE = CSV_FLDR + r'REPOSITIONED_FLIGHTS_SQL_12_' +TODAY+'.csv'
DIVERTED_FLIGHTS_SQL_14_CSV_FILE = CSV_FLDR + r'Diverted_flights_SQL_14' +TODAY+'.csv'
DELAY_INFO_CSV_FILE = CSV_FLDR + r'Delay_Info' +TODAY+'.csv'
UA_SQL_1_2019_CSV_FILE = CSV_FLDR + r'UA_SQL_1_2019' +TODAY+'.csv'
DIVERTS_SQL_5_2019_CSV_FILE = CSV_FLDR + r'DIVERTS_SQL_5_2019' +TODAY+'.csv'
RECOVERED_DIVERTS_2019_CSV_FILE = CSV_FLDR + r'RECOVERED_DIVERTS_2019' +TODAY+'.csv'
UA_L7D_CSV_FILE = CSV_FLDR + r'UA_L7D' +TODAY+'.csv'
UA_Line_CSV_FILE = CSV_FLDR + r'UA_Line' +TODAY+'.csv'



OA_SQL_1_CSV_FILE = CSV_FLDR + r'OA_SQL_1_' +TODAY+'.csv'
OA_SQL_2_CSV_FILE = CSV_FLDR + r'OA_SQL_2_' +TODAY+'.csv'
OA_Line_CSV_FILE = CSV_FLDR + r'OA_Line_' +TODAY+'.csv'


PNG_FILE_SYS1 = PNG_FLDR + TODAY + r' pg1.png'
XLS_SHT_SYS1 = 'pg1'

PNG_FILE_SYS2 = PNG_FLDR + TODAY + r' pg2.png'
XLS_SHT_SYS2 = 'pg2'

PDF_FILE_PATH = PDF_FLDR + YEST + r'_745_UAX' +'.pdf'

logging.basicConfig(filename=LOG_FILE_NAME, level=logging.DEBUG, format='%(asctime)s %(message)s')




def send_error_email(attachment, extra_subject=''):
    email_list_to = ['nikita.rana@united.com','apoorva.singh@united.com']
    #email_list_to = ['nitin.gupta@united.com']

    sender_address = 'nikita.rana@united.com'
    email_subject = "745 Express Report - " + YEST  + extra_subject
    msg = MIMEMultipart()
    msg['Subject'] = email_subject
    msg['To'] = ','.join(email_list_to)
    msg.attach(MIMEText('Please find log attached.', 'html'))

    part = MIMEBase('application', "octet-stream")
    part.set_payload(open(attachment, "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename={0}'.format(os.path.basename(attachment)))
    msg.attach(part)
    
    SMTP_SERVER = 'mailout.ual.com:25'
    smtp_conn = SMTP(SMTP_SERVER)
    smtp_conn.set_debuglevel(False)
    
    smtp_conn.sendmail(sender_address, email_list_to , msg.as_string())
    smtp_conn.quit()
    
    

logging.info('Connecting to Teradata');

#user = 'Prod_spotfire_opfl_oa'
#pasw = 'rptpw0114'
TD2_CRED_PATH = r'D:\Users\Himanshu\Pass\TD2_account_user_pass.csv'

def cred_func(path):
    cred_csv = pd.read_csv(path)
    cred = dict()
    cred['user'] = cred_csv['user'][0]
    cred['pass'] = cred_csv['pass'][0]
    return cred

TD2_CRED = cred_func(TD2_CRED_PATH)
TD2_USER = TD2_CRED['user']
TD2_PASS = TD2_CRED['pass']
host = 'dbccop1.coair.com'
connection = pyodbc.connect('DRIVER=Teradata Database ODBC Driver 17.10;DBCNAME=' + host +';UID=' + TD2_USER + ';PWD=' + TD2_PASS +';QUIETMODE=YES', autocommit=True,unicode_results=True)
cursor = connection.cursor()







logging.info('Checking SuperSnapshot data - yesterdays')
SS_CNT = pd.read_sql('select count(*) as cnt from co_prod_vmdb.rtf_flt_leg_operation_ss where report_dt = date-1', connection)

SS_CNT = SS_CNT['cnt'][0]
logging.info('Number of rows in SuperSnapsot: '+str(SS_CNT))



if SS_CNT < 1000:
        ss_flag = False
else:
        ss_flag = True
   

     
loop=1
while SS_CNT <1000:
    SS_CNT = pd.read_sql(
        'select count(*) as cnt from co_prod_vmdb.rtf_flt_leg_operation_ss where report_dt = date-2', connection)
    SS_CNT = SS_CNT['cnt'][0]
    logging.info('Number of rows in SuperSnapsot: '+str(SS_CNT))
    if SS_CNT > 1000:
        ss_flag = True
        break
    elif loop == 10:
        ss_flag = False
        logging.info('FAILURE: Program Terminating due to max tries.')
        send_error_email(attachment =LOG_FILE_NAME, extra_subject='SS data not availaible')
        exit()
    else:
       logging.info('Waiting for SuperSnapshot to be updated.')
       loop += 1
       time.sleep(600)
      

if ss_flag == True:



    logging.info('Running EDW SQL queries');
    
    
    e1 = open(EDW_SQL_1, 'r')
    sqlEdw1 = e1.read()
    e1.close()
    
    e2 = open(EDW_SQL_2, 'r')
    sqlEdw2 = e2.read()
    e2.close()
    
    e3 = open(EDW_SQL_3, 'r')
    sqlEdw3 = e3.read()
    e3.close()
    
    e4 = open(EDW_SQL_4, 'r')
    sqlEdw4 = e4.read()
    e4.close()
    
    e5 = open(EDW_SQL_5, 'r')
    sqlEdw5 = e5.read()
    e5.close()
    
    e6 = open(EDW_SQL_6, 'r')
    sqlEdw6 = e6.read()
    e6.close()
    
    e7 = open(EDW_SQL_7, 'r')
    sqlEdw7 = e7.read()
    e7.close()
    
    e8 = open(EDW_SQL_8, 'r')
    sqlEdw8 = e8.read()
    e8.close()
    
    e9 = open(EDW_SQL_9, 'r')
    sqlEdw9 = e9.read()
    e9.close()
    
    e10 = open(EDW_SQL_10, 'r')
    sqlEdw10 = e10.read()
    e10.close()
    
    e11 = open(EDW_SQL_11, 'r')
    sqlEdw11 = e11.read()
    e11.close()
    
    e12 = open(EDW_SQL_12, 'r')
    sqlEdw12 = e12.read()
    e12.close()
    
    e13 = open(EDW_SQL_13, 'r')
    sqlEdw13 = e13.read()
    e13.close()
    
    e14 = open(EDW_SQL_14, 'r')
    sqlEdw14 = e14.read()
    e14.close()
    
    e17 = open(DELAYS_SQL, 'r')
    sqlEdw17 = e17.read()
    e17.close()
    
    e18 = open(UA_2019, 'r')
    sqlEdw18 = e18.read()
    e18.close()
    
    e19 = open(DIVERTS_2019, 'r')
    sqlEdw19 = e19.read()
    e19.close()
    
    e20 = open(RECOVERED_2019, 'r')
    sqlEdw20 = e20.read()
    e20.close()
    
    e21 = open(EDW_SQL_15, 'r')
    sqlEdw21 = e21.read()
    e21.close()
    
    e22 = open(EDW_SQL_16, 'r')
    sqlEdw22 = e22.read()
    e22.close()
    
    
    
    
    
    sqlresult_1 = pd.read_sql_query(sqlEdw1, connection)
    sqlresult_1.to_csv(UA_SQL_1_CSV_FILE, index=False)
    
    sqlresult_2 = pd.read_sql_query(sqlEdw2, connection)
    sqlresult_2.to_csv(CNXL_SQL_2_CSV_FILE, index=False)
    
    sqlresult_3 = pd.read_sql_query(sqlEdw3, connection)
    sqlresult_3.to_csv(RES_CNXL_SQL_3_CSV_FILE, index=False)
    
    sqlresult_4 = pd.read_sql_query(sqlEdw4, connection)
    sqlresult_4.to_csv(SCH_DEP_SQL_4_CSV_FILE, index=False)
    
    sqlresult_5 = pd.read_sql_query(sqlEdw5, connection)
    sqlresult_5.to_csv(DIVERTS_SQL_5_CSV_FILE, index=False)
    
    sqlresult_6 = pd.read_sql_query(sqlEdw6, connection)
    sqlresult_6.to_csv(RECOVERED_DIVERTS_SQL_6_CSV_FILE, index=False)
    
    sqlresult_7 = pd.read_sql_query(sqlEdw7, connection)
    sqlresult_7.to_csv(UA_HUB_SQL_7_CSV_FILE, index=False)
    
    sqlresult_10 = pd.read_sql_query(sqlEdw8, connection)
    sqlresult_10.to_csv(FLIGHTS_NOT_DEPARTED_SQL_8_CSV_FILE, index=False)
    
    sqlresult_11 = pd.read_sql_query(sqlEdw9, connection)
    sqlresult_11.to_csv(Cancelled_flights_SQL_9_CSV_FILE, index=False)
    
    sqlresult_12 = pd.read_sql_query(sqlEdw10, connection)
    sqlresult_12.to_csv(Yet_to_Depart_flights_SQL_10_CSV_FILE, index=False)
    
    sqlresult_13 = pd.read_sql_query(sqlEdw11, connection)
    sqlresult_13.to_csv(Residual_cancels_SQL_11_CSV_FILE, index=False)
    
    sqlresult_14 = pd.read_sql_query(sqlEdw12, connection)
    sqlresult_14.to_csv(REPOSITIONED_FLIGHTS_SQL_12_CSV_FILE, index=False)
    
    sqlresult_15 = pd.read_sql_query(sqlEdw13, connection)
    sqlresult_15.to_csv(REPOSITIONED_FLIGHTS_COUNT_SQL_13_CSV_FILE, index=False)
    
    sqlresult_16 = pd.read_sql_query(sqlEdw14, connection)
    sqlresult_16.to_csv(DIVERTED_FLIGHTS_SQL_14_CSV_FILE, index=False)
    
        
    delay_info = pd.read_sql_query(sqlEdw17, connection)
    delay_info.to_csv(DELAY_INFO_CSV_FILE, index=False)
    
    sqlresult_18= pd.read_sql_query(sqlEdw18, connection)
    sqlresult_18.to_csv(UA_SQL_1_2019_CSV_FILE, index=False)
    
    sqlresult_19 = pd.read_sql_query(sqlEdw19, connection)
    sqlresult_19.to_csv(DIVERTS_SQL_5_2019_CSV_FILE, index=False)
    
    sqlresult_20 = pd.read_sql_query(sqlEdw20, connection)
    sqlresult_20.to_csv(RECOVERED_DIVERTS_2019_CSV_FILE, index=False)
    
    sqlresult_21 = pd.read_sql_query(sqlEdw21, connection)
    sqlresult_21.to_csv(UA_L7D_CSV_FILE, index=False)
    
    sqlresult_22 = pd.read_sql_query(sqlEdw22, connection)
    sqlresult_22.to_csv(UA_Line_CSV_FILE, index=False)
    
    logging.info('Running MF SQL queries');
    
    #masflight_connection_string = "mysql+pymysql://mwang:t?dnS)=N=)a\Ck2v@52.201.60.106:3306/masflightdb"
    singlestore_connection_string = "mysql+pymysql://ua_sumit_sharma1:uukexRCsHyAb9kw6rcMX@54.163.228.37:3306/masflightdb_customers_prd?charset=utf8mb4"
    logging.info('Connecting to Masflight')
    
    m1 = open(MF_SQL_1, 'r')
    sqlMf1 = text(m1.read())
    m1.close()
    
    m2 = open(MF_SQL_2, 'r')
    sqlMf2 = text(m2.read())
    m2.close()
    
    m3 = open(MF_SQL_3, 'r')
    sqlMf3 = text(m3.read())
    m3.close()
    
    #sqlresult_8 = pd.read_sql_query(sqlMf1,masflight_connection_string)
    #sqlresult_8.to_clipboard()
    sqlresult_8 = pd.read_sql_query(sqlMf1,singlestore_connection_string)
    #sqlresult_8_new.to_clipboard()
    sqlresult_8.to_csv(OA_SQL_1_CSV_FILE, index=False)
    
    sqlresult_9 = pd.read_sql_query(sqlMf2,singlestore_connection_string)
    sqlresult_9.to_csv(OA_SQL_2_CSV_FILE, index=False)
    
    sqlresult_10 = pd.read_sql_query(sqlMf3,singlestore_connection_string)
    sqlresult_10.to_csv(OA_Line_CSV_FILE, index=False)
    
    logging.info('SQL queries run');
    print('SQL run')
    
    logging.info('Opening excel file');
    
    xlApp = win32com.client.DispatchEx('Excel.Application')
    xlApp.visible = 1
    wb = xlApp.Workbooks.Open(filename)
    
    logging.info('Clearing raw data Sheets');
    
    wb.Application.Run("ClearSheet", "UA_SQL_1_2019")
    wb.Application.Run("ClearSheet", "UA_L7D")
    wb.Application.Run("ClearSheet", "UA_SQL_1")
    wb.Application.Run("ClearSheet", "OA_SQL_1")
    wb.Application.Run("ClearSheet", "OA_SQL_2")
    wb.Application.Run("ClearSheet", "CNXL_SQL_2")
    wb.Application.Run("ClearSheet", "RES_CNXL_SQL_3")
    wb.Application.Run("ClearSheet", "SCH_DEP_SQL_4")
    wb.Application.Run("ClearSheet", "DIVERTS_SQL_5_2019")
    wb.Application.Run("ClearSheet", "TOTAL_DIVERTS_SQL_5")
    wb.Application.Run("ClearSheet", "RECOVERED_DIVERTS_2019")
    wb.Application.Run("ClearSheet", "DIVERTS_RECOVERED_SQL_6")
    wb.Application.Run("ClearSheet", "UA_HUB_SQL_7")
    wb.Application.Run("ClearSheet", "FLIGHTS_NOT_DEPARTED_SQL_8")
    wb.Application.Run("ClearSheet", "REPOSITIONED_FLIGHTS_SQL_13")
    wb.Application.Run("ClearSheet", "UA_Line")
    wb.Application.Run("ClearSheet", "OA_Line")
    wb.Application.Run("ClearSheet", "Delays_Info")
    
    logging.info('Importing data from csv')
    
    
    wb.Application.Run("ImportData", UA_SQL_1_2019_CSV_FILE, "UA_SQL_1_2019")
    wb.Application.Run("ImportData", UA_L7D_CSV_FILE, "UA_L7D")
    wb.Application.Run("ImportData", UA_SQL_1_CSV_FILE, "UA_SQL_1")
    wb.Application.Run("ImportData", OA_SQL_1_CSV_FILE, "OA_SQL_1")
    wb.Application.Run("ImportData", OA_SQL_2_CSV_FILE, "OA_SQL_2")
    wb.Application.Run("ImportData", CNXL_SQL_2_CSV_FILE, "CNXL_SQL_2")
    wb.Application.Run("ImportData", RES_CNXL_SQL_3_CSV_FILE, "RES_CNXL_SQL_3")
    wb.Application.Run("ImportData", SCH_DEP_SQL_4_CSV_FILE, "SCH_DEP_SQL_4")
    wb.Application.Run("ImportData", DIVERTS_SQL_5_2019_CSV_FILE, "DIVERTS_SQL_5_2019")
    wb.Application.Run("ImportData", DIVERTS_SQL_5_CSV_FILE, "TOTAL_DIVERTS_SQL_5")
    wb.Application.Run("ImportData", RECOVERED_DIVERTS_2019_CSV_FILE, "RECOVERED_DIVERTS_2019")
    wb.Application.Run("ImportData", RECOVERED_DIVERTS_SQL_6_CSV_FILE, "DIVERTS_RECOVERED_SQL_6")
    wb.Application.Run("ImportData", UA_HUB_SQL_7_CSV_FILE, "UA_HUB_SQL_7")
    wb.Application.Run("ImportData", FLIGHTS_NOT_DEPARTED_SQL_8_CSV_FILE, "FLIGHTS_NOT_DEPARTED_SQL_8")
    wb.Application.Run("ImportData", REPOSITIONED_FLIGHTS_COUNT_SQL_13_CSV_FILE, "REPOSITIONED_FLIGHTS_SQL_13")
    wb.Application.Run("ImportData",UA_Line_CSV_FILE, "UA_Line")
    wb.Application.Run("ImportData", OA_Line_CSV_FILE, "OA_Line")
    wb.Application.Run("ImportData", DELAY_INFO_CSV_FILE, "Delays_Info")
    
   
    
   
            

            
    logging.info('Creating image')
    wb.Application.Run("createPng2", PNG_FILE_SYS1, XLS_SHT_SYS1)
    wb.Application.Run("createPng2", PNG_FILE_SYS2, XLS_SHT_SYS2)
    
    #logging.info('Creating image')
    #wb.Application.Run("createPng", PNG_FILE_SYS, XLS_SHT_SYS)
   # logging.info('Creating PDF')
   # wb.Application.Run("createPdf", PDF_FILE_PATH)
    
    #wb.Application.Run("createHtmls")
   #wb.Sheets('RANK').Select 
    #z = raw_input()                         # pause the script
    wb.Close()                           # tidy up
    xlApp.Quit()    
    
    
    #logging.info('Creating PDF')
    #wb.Application.Run("createPdf", PDF_FILE_PATH)
    #'''logging.info('Creating HTMLs')
    
    #wb.Application.Run("createHtmls")
    
    
    logging.info('Opening excel file for flight level details');
    
    xlApp = win32com.client.DispatchEx('Excel.Application')
    xlApp.visible = 1
    xlApp.DisplayAlerts = False
    wb = xlApp.Workbooks.Open(filename_attach)
    
    logging.info('Clearing raw data Sheets');
    
    wb.Application.Run("ClearSheetData", "All_cancels")
    wb.Application.Run("ClearSheetData", "Diverted_Flights")
    wb.Application.Run("ClearSheetData", "Yet_to_Depart")
    wb.Application.Run("ClearSheetData", "Residual_cancels")
    wb.Application.Run("ClearSheetData", "Repositioned_Flights")
    
    logging.info('Importing data from csv')
    
    wb.Application.Run("ImportData", Cancelled_flights_SQL_9_CSV_FILE, "All_cancels")
    wb.Application.Run("ImportData", DIVERTED_FLIGHTS_SQL_14_CSV_FILE, "Diverted_Flights")
    wb.Application.Run("ImportData", Yet_to_Depart_flights_SQL_10_CSV_FILE, "Yet_to_Depart")
    wb.Application.Run("ImportData", Residual_cancels_SQL_11_CSV_FILE, "Residual_cancels")
    wb.Application.Run("ImportData", REPOSITIONED_FLIGHTS_SQL_12_CSV_FILE, "Repositioned_Flights")
    
    #removing excel formulae
    wb.Application.Run("All_Cells_In_All_WorkSheets_2")
    
    
    wb.SaveAs(XLS_FILE_PATH)
    xlApp.DisplayAlerts = True
    xlApp.visible = 0
    wb.Close(False)
    
    logging.info('Create image for email')
    print('Create image for email')
    pngSys1 = open(PNG_FILE_SYS1, 'rb')
    pngImageSys1 = MIMEImage(pngSys1.read())
    pngSys1.close()
    pngImageSys1.add_header('Content-ID', '<image'+CID1+'>')
    
    pngSys2 = open(PNG_FILE_SYS2, 'rb')
    pngImageSys2 = MIMEImage(pngSys2.read())
    pngSys2.close()
    pngImageSys2.add_header('Content-ID', '<image'+CID2+'>')
    
    print('Image for email created')
    
    from PIL import Image

    # convert images to PDF - to be used in the email
    Img1= Image.open(PNG_FILE_SYS1)
    Img1 = Img1.convert('RGB')
    
    Img2= Image.open(PNG_FILE_SYS2)
    Img2 = Img2.convert('RGB')
    
  
    
    imagelist = [Img2]
    
    Img1.save(PDF_FILE_PATH, save_all=True, append_images=imagelist)
    
    print('pdf created')
        
    
    
    
    #logging.info('Create image for email')
    ##print('Create image for email')
    #pngSys = open(PNG_FILE_SYS, 'rb')
    #pngImageSys = MIMEImage(pngSys.read())
   # pngSys.close()
    #pngImageSys.add_header('Content-ID', '<image'+CID+'>')
    
    print('Image for email created')
    
    
    #logging.info('HTMLs created')
    #logging.info('Excel saved and closed')
    
    logging.info('Sending email');
    server = smtp.SMTP('mailout.ual.com:25')
    emailFrom = 'sumit.sharma1@united.com'
    emailFromHdr = formataddr((str(Header(r'Sharma, Sumit')), emailFrom))
    
    # Distribution list
    dfEmail = pd.read_csv(EMAIL_ADDR_FILE_TEST, index_col=False)
    listEmailTo = dfEmail['TO'].tolist()
    listEmailTo = [x for x in listEmailTo if str(x) != 'nan']
    
    listEmailCc = dfEmail['CC'].tolist()
    listEmailCc = [x for x in listEmailCc if str(x) != 'nan']
    
    listEmailBcc = dfEmail['BCC'].tolist()
    listEmailBcc = [x for x in listEmailBcc if str(x) != 'nan']
    
    # Create message container - the correct MIME type is multipart/alternative.
    msg = MIMEMultipart()
    msg['From'] = emailFromHdr
    msg['To'] = ','.join(listEmailTo)
    msg['Cc'] = ','.join(listEmailCc)
    msg['Bcc'] = ','.join(listEmailBcc)
    
    msg['Subject'] = "745 Express Report - " + YEST
    
    
    dfEmail = pd.read_csv(EMAIL_ADDR_FILE_TEST, index_col=False)
    
    html_header = """<html>
        	<head></head>
            <STYLE type="text/css">
              BODY {text-align: left}
            </STYLE> 
    	    <body>
    		<p>Hi all,
    		<br>
    		<br>Please see below UAX Daily Snapshot for the date <strong>"""+ YESTERDAY+"""</strong>.
            <br>
    		</p>
    	    </body>
            </html>"""
    		
           
    #HTML_HDR_FILE_PATH = HTML_FLDR + r'EmailHeader.htm'
    #HTML_BDY_FILE_PATH = HTML_FLDR + r'EmailBody.htm'
    #HTML_BDY_PAGE_1_FILE_PATH = HTML_FLDR + r'PAGE_1.htm'
    
    
    html_footer = """<html>
    <p>
    <font face="calibri" size="2">Regards</font>
    <br>
    <font face="calibri" size="2"><span style="color: #1F497D;"><strong>Ops Planning & Analysis</strong></span></font>
    </font>
    </p>
    </html>"""
    #html_body1 = open(HTML_BDY_FILE_PATH, 'r').read()
    html_body1 = """<br><center><img src="cid:image"""+ CID1 +"""" ></center><br><br>"""
    html_body2 = """<br><center><img src="cid:image"""+ CID2 +"""" ></center><br><br>"""
    PDF_part = MIMEBase('application', "octet-stream")
    PDF_part.set_payload(open(PDF_FILE_PATH, "rb").read())
    encoders.encode_base64(PDF_part)
    PDF_part.add_header('Content-Disposition', 'attachment; filename={0}'.format(os.path.basename(PDF_FILE_PATH)))
     
    
    
    email_body = MIMEText(html_header + html_body1 + html_body2 + html_footer, 'html')
    
    xlsx = open(XLS_FILE_PATH, 'rb').read()
    
    #email_body = MIMEText(html_header + html_footer, 'html')
    
    msgXlsx = MIMEApplication(xlsx, 'xlsm')  # pdf for exemple
    msgXlsx.add_header('Content-ID', '<xlsx1>')  # if no cid, mail.app (only one?) don't show the attachment
    msgXlsx.add_header('Content-Disposition', 'attachment', filename=XLS_FILE_NAME)
    msgXlsx.add_header('Content-Disposition', 'inline', filename=XLS_FILE_NAME)
    
    
    
    
    msg.attach(email_body)
    msg.attach(pngImageSys1)
    msg.attach(pngImageSys2)
    msg.attach(PDF_part)
    msg.attach(msgXlsx)
    
    server.sendmail(emailFrom, listEmailTo + listEmailCc + listEmailBcc, msg.as_string())
            
    logging.info('Email sent and process is completed');
            
     
    
    print('Email sent')
    
    connection.execute("""INSERT INTO OPFL_TEMP_DB.REPORTS_MONITORING (REPORT_TIME, REPORT_NAME,EMAIL_SUCCESS,ROWS_COUNT,ERROR_MSG)

                           VALUES (CURRENT_TIMESTAMP,'745_UAX','Y',0,'None')""") 
    
    server.quit()

else:
    send_error_email(attachment =LOG_FILE_NAME, extra_subject='Report failed due to data unavailaibility')
    
    connection.execute("""INSERT INTO OPFL_TEMP_DB.REPORTS_MONITORING (REPORT_TIME, REPORT_NAME,EMAIL_SUCCESS,ROWS_COUNT,ERROR_MSG)

                           VALUES (CURRENT_TIMESTAMP,'745_UAX','N',0,'Data unavailability')""")
    

    connection.close()
