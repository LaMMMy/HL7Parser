using NHapi.Model.V23.Group;
using NHapi.Model.V23.Message;
using NHapi.Model.V23.Segment;
using System.Collections.Generic;

namespace HL7Parser.Models
{
    public class ParsedORUViewModel
    {
        public ORU_R01 ORUMessage { get; set; }
        public string OriginalMessage { get; set; }
        public PID PID { get; set; }
        public ORU_R01_VISIT PV1 { get; set; }
        public List<ORU_R01_ORDER_OBSERVATION> OBR { get; set; }
        public ORC ORC { get; set; }
        public List<ORU_R01_OBSERVATION> OBX { get; set; }
    }
}