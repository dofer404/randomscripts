#!/usr/bin/python

DEFAULTFROMADDR = 'source@gmail.com'
DEFAULTTOADDR = 'destination@gmail.com'
DEFAULTSUBJECT = 'some unique subject'
DEFAULTPASS = 'password'
DEFAULTFILE_LAST = '/somefolder/last'
DEFAULT_MAILFOLDER = 'someMailFolder-or-label'

def enviarMail(msg_body):
    import smtplib
    from email.MIMEMultipart import MIMEMultipart
    from email.MIMEText import MIMEText
    fromaddr = DEFAULTFROMADDR
    toaddr = DEFAULTTOADDR
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Cc'] = fromaddr
    msg['Subject'] = DEFAULTSUBJECT

    body = msg_body
    msg.attach(MIMEText(body, 'plain'))

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(fromaddr, DEFAULTPASS)
    text = msg.as_string()
    server.sendmail(fromaddr, msg["To"].split(",") + msg["Cc"].split(","), text)
    server.quit()

def leerDato():
    import urllib2
    html = urllib2.urlopen('http://ip.42.pl/raw').read()
    return html

import datetime
fechaInicio = datetime.datetime.now()
print " = Hora de inicio = "
print fechaInicio

ultimo = 0.0
try:
    input_file = open(DEFAULTFILE_LAST,"r")
    #output_fileDec = open("Dic9812.TFITF.decoded.txt","w")
    #output_fileLog = open("Dic9812.TFITF.log.txt","w")
    for line in input_file:
        for numstr in line.split(","):
            if numstr:
                try:
                    ultimo = float(numstr)
                except ValueError as e:
                    print('Error al leer floats desde "' + DEFAULTFILE_LAST + '"')
                    print(e)
    input_file.close()
except IOError:
    print('no se encontro "' + DEFAULTFILE_LAST + '"')

import time
import imaplib
mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login(DEFAULTFROMADDR, DEFAULTPASS)
mail.list()
# Out: list of "folders" aka labels in gmail.
mail.select(DEFAULT_MAILFOLDER) # connect to somefolder.

result, data = mail.search(None, "ALL")
ids = data[0] # data is a list.
id_list = ids.split() # ids is a space separated string
latest_email_id = id_list[-1] # get the latest

result, data = mail.fetch(latest_email_id, "(RFC822)") # fetch the email body (RFC822) for the given ID
raw_email = data[0][1] # here's the body, which is raw text of the whole email

import email
email_message = email.message_from_string(raw_email)
# partes = email_message.items() # print all headers

quienes = email.utils.parseaddr(email_message['From'])[1] # for parsing "Yuji Tomita" <yuji@grovemade.com>
fecha = time.mktime(email.utils.parsedate(email_message['Date']))

if (quienes == DEFAULTTOADDR) or (quienes == DEFAULTFROMADDR):
    if email_message['Subject'] == DEFAULTSUBJECT: #email_message.items()['Subject'] # print Subject
        if fecha > ultimo:
            print quienes + ' solicita ayuda'
            msg = leerDato() + " :)"
            mailEnviado = True
            try:
                enviarMail(msg)
            except Exception as e:
                print("algo fallo al intentar enviar el mail")
                print(e)
                mailEnviado = False
            if mailEnviado:
                try:
                    output_file = open(DEFAULTFILE_LAST, "w")
                    linea_s = str(fecha)
                    output_file.write(linea_s)
                    output_file.close()
                except IOError as e:
                    print('algo fallo al intentar escribir en "' + DEFAULTFILE_LAST + '"')
                    print(e)
        else:
            print 'Solicitud de ' + quienes + ' ya atendida ;)'
        print "Fecha de solicitud: " + time.asctime(time.localtime(fecha))
    else:
        print 'No es mensaje para este bot'

# note that if you want to get text content (body) and the email contains
# multiple payloads (plaintext/ html), you must parse each message separately.
# use something like the following: (taken from a stackoverflow post)
def get_first_text_block(email_message_instance):
    maintype = email_message_instance.get_content_maintype()
    print maintype
    if maintype == 'multipart':
        noencontrado = True
        for part in email_message_instance.get_payload():
            if part.get_content_maintype() == 'text':
                noencontrado = False
                print part.get_content_maintype()
                return part.get_payload()
        if noencontrado:
            return "<sin maintype conocido>"
    elif maintype == 'text':
        return email_message_instance.get_payload()
    else:
        return "<sin maintype conocido>"

#print get_first_text_block(email_message)
