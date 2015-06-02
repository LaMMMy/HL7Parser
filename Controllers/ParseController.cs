using HL7Parser.Models;
using NHapi.Base.Model;
using NHapi.Base.Parser;
using NHapi.Model.V23.Group;
using NHapi.Model.V23.Message;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace HL7Parser.Controllers
{
    public class ParseController : Controller
    {
        static HL7Message messageToParse = new HL7Message();

        // GET: Parse
        public ActionResult Index()
        {
            return View(messageToParse);
        }

        public ActionResult Details()
        {
            PipeParser parser = new PipeParser();

            //ORU_R01 mess = (ORU_R01)messageToParse.ParsedData;

            var msg = parser.Parse(messageToParse.MessageData);
            // Convert from HL7 object to XML
            XMLParser xmlParser = new DefaultXMLParser();
            string sXML = xmlParser.Encode(msg);
            System.IO.File.WriteAllText(@"D:\TEMP\path.txt", sXML);

            if (msg.GetStructureName() == "ORU_R01")
            {
                // populate a strongly typed object so we can access everything.
                ParsedORUViewModel oru = new ParsedORUViewModel();
                oru.OriginalMessage = messageToParse.MessageData;
                oru.ORUMessage = (ORU_R01)parser.Parse(messageToParse.MessageData, "2.3");

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

                return View("ParseView", oru);
            }
            //oru.PID.PID//.AlternatePatientID//.DateOfBirth//.PrimaryLanguage//.Race//.Religion//.SSNNumberPatient//Sex//PatientName




            //Terser terser = new Terser(messageToParse.ParsedData);
            return View("ParseView", msg);

        }

        private static NHapi.Base.Model.IMessage ExtractAndAssignMessage(NHapi.Base.Model.IMessage mess)
        {
            switch (mess.GetStructureName())
            {
                case "ORU_R01":
                    mess = (NHapi.Model.V23.Message.ORU_R01)mess;
                    break;
                default:
                    break;
            }

            return mess;
        }

        //
        // GET: /Parse/Create
        public ActionResult Create()
        {
            var model = new HL7Message();
            model.MessageData = @"MSH|^~\&|LAB|IHVJH|LAB||201411130917||ORU^R01|3216598|D|2.3|||AL|NE|
PID|1|A00012584|A00012584_PID3|{PID_4}|Pthvjhsot^test^kyla2||19670202|F||PID.10_Race|4505 21 st^^LAKE COUNTRY^BC^V4V 2S7|CA|250-558-1200|250-454-2343|PID.15_Language|M|Religion|VJ0050356/15|
PV1|1|O|VERVJHLPTH||||PV1.7^Savarie^Donna^^^^^SAVDPV1.7|PV1.8^Savarie^Donna^^^^^SAVDPV1.8|PV1.9^Savarie^Donna^^^^^SAVDPV1.9|||||||||REF||SELF|||||||||||||||||||IHVJH||REG|||201411071440||||||||23390^PV1_52Surname^PV1_52Given^H^^Dr^^PV1_52Mnemonic|
ORC|RE|PT103933301.0100|||CM|N|||201411130917|^Kyle^Andra^J.^^^^KYLA||^Savarie^Donna^^^^^SAVD|IHVJH|
OBR|1|PT1311:H00001R301.0100|PT1311:H00001R|301.0100^Complete Blood Count (CBC)^00065227^57021-8^CBC \T\ Auto Differential^pCLOCD|R||201411130914|||KYLA||||201411130914||^Savarie^Donna^^^^^SAVD||00065227||||201411130915||LAB|F||^^^^^R|^Savarie^Donna^^^^^SAVD|
OBX|1|NM|301.0500^White Blood Count (WBC)^00065227^6690-2^Leukocytes^pCLOCD|1|10.1|10\S\9/L|3.1-9.7|H||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|2|NM|301.0600^Red Blood Count (RBC)^00065227^789-8^Erythrocytes^pCLOCD|1|3.2|10\S\12/L|3.7-5.0|L||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|3|NM|301.0700^Hemoglobin (HGB)^00065227^718-7^Hemoglobin^pCLOCD|1|140|g/L|118-151|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|4|NM|301.0900^Hematocrit (HCT)^00065227^4544-3^Hematocrit^pCLOCD|1|0.34|L/L|0.33-0.45|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|5|NM|301.1100^MCV^00065227^787-2^Mean Corpuscular Volume^pCLOCD|1|98.0|fL|84.0-98.0|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|6|NM|301.1300^MCH^00065227^785-6^Mean Corpuscular Hemoglobin^pCLOCD|1|27.0|pg|28.3-33.5|L||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|7|NM|301.1500^MCHC^00065227^786-4^Mean Corpuscular Hemoglobin Concentration^pCLOCD|1|330|g/L|329-352|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|8|NM|301.1700^RDW^00065227^788-0^Erythrocyte Distribution Width^pCLOCD|1|12.0|%|12.0-15.0|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|9|NM|301.1900^Platelets^00065227^777-3^Platelets^pCLOCD|1|125|10\S\9/L|147-375|L||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|10|NM|301.2100^Neutrophils^00065227^751-8^Neutrophils^pCLOCD|1|8.0|10\S\9/L|1.2-6.0|H||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|11|NM|301.2300^Lymphocytes^00065227^731-0^Lymphocytes^pCLOCD|1|1.0|10\S\9/L|0.6-3.1|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|12|NM|301.2500^Monocytes^00065227^742-7^Monocytes^pCLOCD|1|1.0|10\S\9/L|0.1-0.9|H||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|13|NM|301.2700^Eosinophils^00065227^711-2^Eosinophils^pCLOCD|1|0.0|10\S\9/L|0.0-0.5|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
OBX|14|NM|301.2900^Basophils^00065227^704-7^Basophils^pCLOCD|1|0.0|10\S\9/L|0.0-0.2|N||A~S|F|||201411130916|IHVJH^Vernon Jubilee Hosp^L|
ZDR||^Savarie^Donna^^^^^SAVD^^^^^XX^^ATP|
ZPR||";
            return View(model);
        }

        //
        // POST: /Parse/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                messageToParse.MessageData = collection["MessageData"];
                return RedirectToAction("Details");
            }
            catch
            {
                return View();
            }
        }

        // Code in this region is based on code from HL7 Snoop, (c) Veraida Pty Ltd

        public class Field
        {
            public string Id { get; set; }
            public string Name { get; set; }
            public string Value { get; set; }
        }

        public class FieldGroup : Field
        {
            public FieldGroup()
            {
                this.FieldList = new List<object>();
            }
            public List<object> FieldList { get; set; }
        }

        /// <summary>
        /// Processes a structure group.
        /// A structure group is, primarily, a group of segments.  This could either be the entire
        /// message or special segments that need to be grouped together.  An example of this is
        /// the result segments (OBR, OBX and NTE), these are grouped together in the model
        /// definition (e.g. REF_I12_RESULTS_NOTES).
        /// </summary>
        /// <param name="structureGroup">The structure group.</param>
        /// <param name="parentNode">The parent node, in the TreeListView.</param>
        private void ProcessStructureGroup(AbstractGroup structureGroup, FieldGroup parentNode)
        {
            foreach (string segName in structureGroup.Names)
            {
                foreach (IStructure struc in structureGroup.GetAll(segName))
                {
                    this.ProcessStructure(struc, parentNode);
                }
            }
        }

        /// <summary>
        /// Processes the structure.
        /// A base structure can be either a segment, or segment group. This function
        /// determines which it is before passing it on.
        /// </summary>
        /// <param name="structure">The structure.</param>
        /// <param name="parentNode">The parent node, in the TreeListView.</param>
        private void ProcessStructure(IStructure structure, FieldGroup parentNode)
        {
            if (structure.GetType().IsSubclassOf(typeof(AbstractSegment)))
            {
                AbstractSegment seg = (AbstractSegment)structure;
                this.ProcessSegment(seg, parentNode);
            }
            else if (structure.GetType().IsSubclassOf(typeof(AbstractGroup)))
            {
                AbstractGroup structureGroup = (AbstractGroup)structure;
                this.ProcessStructureGroup(structureGroup, parentNode);
            }
            else
            {
                parentNode.FieldList.Add(new Field() { Name = "Something Else!!!" });
            }
        }

        /// <summary>
        /// Processes the segment.
        /// Loops through all of the fields within the segment, and parsing them individually.
        /// </summary>
        /// <param name="segment">The segment.</param>
        /// <param name="parentNode">The parent node.</param>
        private void ProcessSegment(AbstractSegment segment, FieldGroup parentNode)
        {
            FieldGroup segmentNode = new FieldGroup() { Name = segment.GetStructureName(), Id = segment.GetStructureName() };
            int dataItemCount = 0;

            for (int i = 1; i <= segment.NumFields(); i++)
            {
                dataItemCount++;
                IType[] dataItems = segment.GetField(i);
                foreach (IType item in dataItems)
                {
                    this.ProcessField(item, segment.GetFieldDescription(i), dataItemCount.ToString(), segmentNode);
                }
            }

            this.AddChildGroup(parentNode, segmentNode);
        }

        /// <summary>
        /// Processes the field.
        /// Determines the type of field, before passing it onto the more specific parsing functions.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private void ProcessField(IType item, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            if (item.GetType().IsSubclassOf(typeof(AbstractPrimitive)))
            {
                this.ProcessPrimitiveField((AbstractPrimitive)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType() == typeof(Varies))
            {
                this.ProcessVaries((Varies)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType().GetInterfaces().Contains(typeof(IComposite)))
            {
                AbstractType dataType = (AbstractType)item;
                string desc = string.IsNullOrEmpty(dataType.Description) ? fieldDescription : dataType.Description;
                this.ProcessCompositeField((IComposite)item, desc, fieldCount, parentNode);
            }
        }

        /// <summary>
        /// Processes the primitive field.
        /// A primitive field is the most basic type (i.e. no composite fields).  This function retrieves the data
        /// and builds the node in the TreeListView.
        /// </summary>
        /// <param name="dataItem">The data item.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private void ProcessPrimitiveField(AbstractPrimitive dataItem, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            string desc = fieldDescription == string.Empty ? dataItem.Description : fieldDescription;

            string typnam = System.Text.RegularExpressions.Regex.Replace(dataItem.TypeName, @"ComponentOne", @"1");

            desc += ":" + typnam;

            if (!string.IsNullOrEmpty(dataItem.Value))
            {
                parentNode.FieldList.Add(new Field() { Name = desc, Id = parentNode.Id + "." + fieldCount, Value = dataItem.Value });
            }
        }

        /// <summary>
        /// Processes the varies.
        /// "Varies" are the data in the OBX segment, the sending application can set the type hence generically the OBX 
        /// value field is a variant type. 
        /// The "Varies" data parameter contains the data in type IType (hence being passed back to process field).
        /// </summary>
        /// <param name="varies">The varies.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private void ProcessVaries(Varies varies, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            this.ProcessField(varies.Data, fieldDescription, fieldCount, parentNode);
        }

        /// <summary>
        /// Processes the composite field.
        /// A composite field is a group of fields, such as "Coded Entry".
        /// This function breaks up the composite field and passes each field back to "ProcessField"
        /// </summary>
        /// <param name="composite">The composite.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private void ProcessCompositeField(IComposite composite, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            string desc = fieldDescription + ":" + composite.TypeName;
            FieldGroup subParent = new FieldGroup() { Name = desc, Id = parentNode.Id + "." + fieldCount };

            int subItemCount = 0;
            foreach (IType subItem in composite.Components)
            {
                subItemCount++;
                this.ProcessField(subItem, string.Empty, subItemCount.ToString(), subParent);
            }

            this.AddChildGroup(parentNode, subParent);
        }

        /// <summary>
        /// Adds the child group, to the parent node, only if the child group acutally contains fields.
        /// </summary>
        /// <param name="parentNode">The parent node.</param>
        /// <param name="childGroup">The child group.</param>
        private void AddChildGroup(FieldGroup parentNode, FieldGroup childGroup)
        {
            if (childGroup.FieldList.Count > 0)
            {
                parentNode.FieldList.Add(childGroup);
            }
        }
    }
}