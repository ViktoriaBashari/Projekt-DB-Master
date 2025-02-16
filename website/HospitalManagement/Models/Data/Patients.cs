namespace HospitalManagement.Models.Data
{
    public class Pacient
    {
        public int Id { get; set; }
        public string Emri { get; set; } = string.Empty;
        public string Mbiemri { get; set; } = string.Empty;
        public int Mosha { get; set; }
        public string Gjinia { get; set; } = string.Empty;
    }
}
