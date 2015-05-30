using NHapi.Base.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HL7Parser.Models
{
    public class HL7Message
    {
        [Key]
        public int ID { get; set; }
        public string MessageData { get; set; }
        public IMessage ParsedData { get; set; }
    }
}