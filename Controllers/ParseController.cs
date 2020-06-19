using HL7Parser.Helpers;
using HL7Parser.Models;
using NHapi.Base.Model;
using NHapi.Base.Parser;
using NHapi.Model.V23.Group;
using NHapi.Model.V23.Message;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.Xsl;

namespace HL7Parser.Controllers
{
    public class ParseController : BaseController
    {
        static ParsedMessageViewModel messageToParse = new ParsedMessageViewModel();

        // GET: Parse
        public ActionResult Index()
        {
            return View(messageToParse);
        }

        public ActionResult Samples()
        {
            return View();
        }

        public ActionResult Details()
        {
            PipeParser parser = new PipeParser();

            var msg = parser.Parse(messageToParse.OriginalMessage);

            var fieldGroupList = new List<FieldGroup>();

            try
            {
                FieldGroup messageGroup = new FieldGroup() { Name = msg.GetStructureName() };
                ProcessHelper.ProcessStructureGroup((AbstractGroup)msg, messageGroup);

                fieldGroupList.Add(messageGroup);
            }
            catch (Exception ex)
            {
                // ignore for now?
                Danger($"Exception processing message structure. {ex.GetExceptionMessageWithInner()}");
            }

            if (msg.GetStructureName() == "ORU_R01")
            {
                // populate a strongly typed object so we can access everything.
                ParsedORUViewModel oru = new ParsedORUViewModel();
                oru.OriginalMessage = messageToParse.OriginalMessage;
                oru.ORUMessage = (ORU_R01)parser.Parse(messageToParse.OriginalMessage, "2.3");

                var oruResponse = oru.ORUMessage.GetRESPONSE();
                oru.PID = oruResponse.PATIENT.PID;
                oru.PV1 = oruResponse.PATIENT.VISIT;
                oru.OBR = new List<ORU_R01_ORDER_OBSERVATION>();

                for (int i = 0; i < oruResponse.ORDER_OBSERVATIONRepetitionsUsed; i++)
                {
                    var obr = oruResponse.GetORDER_OBSERVATION(i);
                    var orc = obr.ORC;
                    oru.OBR.Add(obr);
                    oru.OBX = new List<ORU_R01_OBSERVATION>();
                    for (int f = 0; f < obr.OBSERVATIONRepetitionsUsed; f++)
                    {
                        var obx = obr.GetOBSERVATION(f);
                        oru.OBX.Add(obx);
                    }
                }

                oru.MessageTree = fieldGroupList;

                return View("Details", oru);
            }
            else if (msg.GetStructureName().Contains("ADT"))
            {
                var adtMessage = new ParsedMessageViewModel();
                adtMessage.OriginalMessage = messageToParse.OriginalMessage;
                //adtMessage.PIDSegment = (ORU_R01)parser.Parse(messageToParse.OriginalMessage, "2.3");
            }

            return View("Details", msg);
        }


        //
        // GET: /Parse/Create
        public ActionResult Create()
        {
            ParsedMessageViewModel model = new ParsedMessageViewModel();
            model.OriginalMessage = @"
MSH|^~\&|AccMgr|1|||20050110045504||ADT^A08|599102|P|2.3|||
EVN|A01|20050110045502|||||
PID|1||10006579^^^1^MRN^1||DUCK^DONALD^D||19241010|M||1|111 DUCK ST^^FOWL^CA^999990000^^M|1|8885551212|8885551212|1|2||40007716^^^AccMgr^VN^1|123121234|||||||||||NO
NK1|1|DUCK^HUEY|SO|3583 DUCK RD^^FOWL^CA^999990000|8885552222||Y||||||||||||||
PV1|1|I|PREOP^101^1^1^^^S|3|||37^DISNEY^WALT^^^^^^AccMgr^^^^CI|||01||||1|||37^DISNEY^WALT^^^^^^AccMgr^^^^CI|2|40007716^^^AccMgr^VN|4|||||||||||||||||||1||G|||20050110045253||||||
GT1|1|8291|DUCK^DONALD^D||111^DUCK ST^^FOWL^CA^999990000|8885551212||19241010|M||1|123121234||||#Cartoon Ducks Inc|111^DUCK ST^^FOWL^CA^999990000|8885551212||PT|
DG1|1|I9|71596^OSTEOARTHROS NOS-L/LEG ^I9|OSTEOARTHROS NOS-L/LEG ||A|
IN1|1|MEDICARE|3|MEDICARE|||||||Cartoon Ducks Inc|19891001|||4|DUCK^DONALD^D|1|19241010|111^DUCK ST^^FOWL^CA^999990000|||||||||||||||||123121234A||||||PT|M|111 DUCK ST^^FOWL^CA^999990000|||||8291
IN2|1||123121234|Cartoon Ducks Inc|||123121234A|||||||||||||||||||||||||||||||||||||||||||||||||||||||||8885551212
IN1|2|NON-PRIMARY|9|MEDICAL MUTUAL CALIF.|PO BOX 94776^^HOLLYWOOD^CA^441414776||8003621279|PUBSUMB|||Cartoon Ducks Inc||||7|DUCK^DONALD^D|1|19241010|111 DUCK ST^^FOWL^CA^999990000|||||||||||||||||056269770||||||PT|M|111^DUCK ST^^FOWL^CA^999990000|||||8291
IN2|2||123121234|Cartoon Ducks Inc||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||8885551212
IN1|3|SELF PAY|1|SELF PAY|||||||||||5||1";

            //            @"MSH |^~\&|LAB|MYFAC|LAB||201411130917||ORU^R01|3216598|D|2.3|||AL|NE|
            //PID|1|ABC123DF|AND234DA_PID3|PID_4_ALTID|Patlast^Patfirst^Mid||19670202|F|||4505 21 st^^LAKE COUNTRY^BC^V4V 2S7||222-555-8484|||||MF0050356/15|
            //PV1|1|O|MYFACSOMPL||||^Xavarie^Sonna^^^^^XAVS|||||||||||REF||SELF|||||||||||||||||||MYFAC||REG|||201411071440||||||||23390^PV1_52Surname^PV1_52Given^H^^Dr^^PV1_52Mnemonic|
            //ORC|RE|PT103933301.0100|||CM|N|||201411130917|^Kyle^Andra^J.^^^^KYLA||^Xavarie^Sonna^^^^^XAVS|MYFAC|
            //OBR|1|PT1311:H00001R301.0100|PT1311:H00001R|301.0100^Complete Blood Count (CBC)^00065227^57021-8^CBC \T\ Auto Differential^pCLOCD|R||201411130914|||KYLA||||201411130914||^Xavarie^Sonna^^^^^XAVS||00065227||||201411130915||LAB|F||^^^^^R|^Xavarie^Sonna^^^^^XAVS|
            //OBX|1|NM|301.0500^White Blood Count (WBC)^00065227^6690-2^Leukocytes^pCLOCD|1|10.1|10\S\9/L|3.1-9.7|H||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|2|NM|301.0600^Red Blood Count (RBC)^00065227^789-8^Erythrocytes^pCLOCD|1|3.2|10\S\12/L|3.7-5.0|L||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|3|NM|301.0700^Hemoglobin (HGB)^00065227^718-7^Hemoglobin^pCLOCD|1|140|g/L|118-151|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|4|NM|301.0900^Hematocrit (HCT)^00065227^4544-3^Hematocrit^pCLOCD|1|0.34|L/L|0.33-0.45|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|5|NM|301.1100^MCV^00065227^787-2^Mean Corpuscular Volume^pCLOCD|1|98.0|fL|84.0-98.0|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|6|NM|301.1300^MCH^00065227^785-6^Mean Corpuscular Hemoglobin^pCLOCD|1|27.0|pg|28.3-33.5|L||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|7|NM|301.1500^MCHC^00065227^786-4^Mean Corpuscular Hemoglobin Concentration^pCLOCD|1|330|g/L|329-352|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|8|NM|301.1700^RDW^00065227^788-0^Erythrocyte Distribution Width^pCLOCD|1|12.0|%|12.0-15.0|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|9|NM|301.1900^Platelets^00065227^777-3^Platelets^pCLOCD|1|125|10\S\9/L|147-375|L||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|10|NM|301.2100^Neutrophils^00065227^751-8^Neutrophils^pCLOCD|1|8.0|10\S\9/L|1.2-6.0|H||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|11|NM|301.2300^Lymphocytes^00065227^731-0^Lymphocytes^pCLOCD|1|1.0|10\S\9/L|0.6-3.1|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|12|NM|301.2500^Monocytes^00065227^742-7^Monocytes^pCLOCD|1|1.0|10\S\9/L|0.1-0.9|H||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|13|NM|301.2700^Eosinophils^00065227^711-2^Eosinophils^pCLOCD|1|0.0|10\S\9/L|0.0-0.5|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //OBX|14|NM|301.2900^Basophils^00065227^704-7^Basophils^pCLOCD|1|0.0|10\S\9/L|0.0-0.2|N||A~S|F|||201411130916|MYFAC^MyFake Hospital^L|
            //ZDR||^Xavarie^Sonna^^^^^XAVS^^^^^XX^^ATP|
            //ZPR||";
            return View(model);
        }

        //
        // POST: /Parse/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                messageToParse.OriginalMessage = collection["OriginalMessage"].Trim();
                return RedirectToAction("ParseView");
            }
            catch (Exception ex)
            {
                Danger($"Something wrong with HL7 Message. {ex.GetExceptionMessageWithInner()}");
                return View();
            }
        }

        // When the "Reparse" Button is pressed.
        // POST: /Parse/ParseView
        [HttpPost]
        public ActionResult ParseView(FormCollection collection)
        {
            ParsedMessageViewModel viewModel = new ParsedMessageViewModel();
            try
            {
                messageToParse.OriginalMessage = collection["OriginalMessage"];

                return RedirectToAction("ParseView");
            }
            catch (Exception ex)
            {
                Danger($"Looks like something went wrong. {ex.GetExceptionMessageWithInner()}");
                return View(viewModel);
            }
        }

        public ActionResult ParseView()
        {
            PipeParser parser = new PipeParser();

            // Determine the message version, fix it if necessary
            string messageVersion = GetMessageVersion();

            ParsedMessageViewModel viewModel = new ParsedMessageViewModel();

            try
            {
                viewModel.OriginalMessage = messageToParse.OriginalMessage;

                var message = parser.Parse(messageToParse.OriginalMessage, "2." + messageVersion);

                var fieldGroupList = new List<FieldGroup>();

                // create FieldGroup for us in the treeview
                FieldGroup treeGroup = new FieldGroup() { Name = message.GetStructureName() };
                ProcessHelper.ProcessStructureGroup((AbstractGroup)message, treeGroup);

                fieldGroupList.Add(treeGroup);

                viewModel.MessageTree = fieldGroupList;

                viewModel.OriginalXml = GenerateXml(message);
                viewModel.TransformedXML = TransformXml(viewModel.OriginalXml);

            }
            catch (Exception ex)
            {
                Danger($"Something wrong with HL7 Message. {ex.GetExceptionMessageWithInner()}");

                return View("ParseView", viewModel);
            }

            return View("ParseView", viewModel);
        }

        private string GetMessageVersion()
        {
            // Determine the message version, fix it if necessary
            string messageVersion = "4";
            string messageVersionRegex = @"(^MSH.*)(\|2\.)(\d)(\|)";
            Match versionMatch = Regex.Match(messageToParse.OriginalMessage, messageVersionRegex);
            if (versionMatch.Success)
            {
                messageVersion = versionMatch.Groups[3].Value;
                switch (messageVersion)
                {
                    case "1": // Force version 2.1 to 2.2
                        messageVersion = "2";
                        Warning("Parsing as a Version 2." + messageVersion + " message.");
                        break;

                    case "6": // Force version 2.6 to 2.5
                        messageVersion = "5";
                        Warning("Parsing as a Version 2." + messageVersion + " message.");
                        break;
                }
            }

            return messageVersion;
        }

        /// <summary>
        /// Generates an xml string using the NHapi XMLParser.
        /// </summary>
        /// <param name="message"></param>
        /// <returns></returns>
        private string GenerateXml(IMessage message)
        {
            // Convert from HL7 object to XML
            XMLParser xmlParser = new DefaultXMLParser();
            string sXML = xmlParser.Encode(message);

            string sRootNamespace = @"<([A-Z0-9_]+) xmlns=(.*?)/(\1)>";
            System.Text.RegularExpressions.Match mx = System.Text.RegularExpressions.Regex.Match(sXML, sRootNamespace);
            if (mx.Success)
            {
                // lError.Text = "Replacing root element with new namespace.";
                sXML = System.Text.RegularExpressions.Regex.Replace(sXML, sRootNamespace, @"<ns0:$1 xmlns:ns0=$2/ns0:$1>");
            }

            return sXML;
        }

        /// <summary>
        /// Transforms XML based on the transform supplied.
        /// </summary>
        /// <param name="sXML"></param>
        /// <returns></returns>
        private static string TransformXml(string sXML)
        {
            XmlWriterSettings xmlSettings = new XmlWriterSettings();
            xmlSettings.Indent = true;
            xmlSettings.Encoding = Encoding.Unicode;
            xmlSettings.NewLineHandling = NewLineHandling.Replace;
            xmlSettings.ConformanceLevel = ConformanceLevel.Document;

            XslCompiledTransform transformer = new XslCompiledTransform();
            transformer.Load(AppDomain.CurrentDomain.BaseDirectory + "\\Resources\\HL7XmlToHTML.xslt");

            StringBuilder xmlStringBuilder = new StringBuilder();
            XmlReader xmlInput = XmlReader.Create(new StringReader(sXML));
            XmlWriter xmlHolder = XmlWriter.Create(xmlStringBuilder, xmlSettings);
            transformer.Transform(xmlInput, xmlHolder);

            //XslCompiledTransform transformer = new XslCompiledTransform();
            //using (var textReader = XmlReader.Create(new StringReader(Properties.Resources.HL7XmlToHTML)))
            //{
            //    transformer.Load(textReader);
            //    XmlReader xmlInput = XmlReader.Create(new StringReader(sXML));
            //    XmlWriter xmlHolder = XmlWriter.Create(xmlStringBuilder, xmlSettings);

            //    transformer.Transform(xmlInput, xmlHolder);
            //}

            return xmlStringBuilder.ToString();
        }
    }
}