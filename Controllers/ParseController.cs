using HL7Parser.Models;
using NHapi.Base.Parser;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NHapi.Model.

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
//            MSH|^~\&||GA0000||MA0000|199705221605||VXQ^V01|19970522GA40|T|2.3.1|||AL
//QRD|199705221605|R|I|19970522GA05|||25^RD|^KENNEDY^JOHN^FITZGERALD^JR|VXI^VACCINE INFORMATION^HL70048|^SIIS
//QRF|MA0000||||256946789~19900607~MA~MA99999999~88888888~KENNEDY^JACQUELINE^LEE~BOUVIER~898666725~KENNEDY^JOHN^FITZGERALD~822546618
            PipeParser parser = new PipeParser();
            
            messageToParse.ParsedData = parser.Parse(messageToParse.MessageData);
            var mess = messageToParse.ParsedData.Message;
            if(mess.Version == "2.3")
            {
                if(mess.GetStructureName() == "VXQ_V01")
                {
                    mess = (NHapi.Model.V23.Message.VXQ_V01) mess;
                    //NHapi.Model.V23.Message.VXQ_V01 a = mess as NHapi.Model.V23.Message.VXQ_V01;
                }
            }
            if(mess.Version == "2.31")
            {

            }
            if(mess.Version == "2.4")
            {

            }
            if(mess.Version == "2.5")
            {

            }
            messageToParse.ParsedData.Message = mess;
            return View("ParseView", messageToParse);
        }

        //
        // GET: /Parse/Create
        public ActionResult Create()
        {
            return View();
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
    }
}