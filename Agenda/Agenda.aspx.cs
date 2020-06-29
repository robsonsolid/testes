using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
public partial class _Default : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        hdnLiberacao.Value = "2";
    }


    [WebMethod()]
    public static String MontaSalaTerapeuta(String cod_filial,String cod_terapeuta)
    {

        List<resources> resources = new List<resources>();

        String conexao = ConfigurationManager.ConnectionStrings["conexao"].ConnectionString;
        SqlConnection con = new SqlConnection();
        con.ConnectionString = conexao.ToString();

        SqlCommand cmd = new SqlCommand();

        String ssql = "";
        ssql = @"  select ds_sala,cod_sala,fil.ds_filial from tb_sala s
                              inner join tb_filial fil on fil.cod_filial = s.cod_filial
                               where 1=1";
        if (cod_filial != "0")
        {
            ssql += "  and fil.cod_filial =" + cod_filial;
        }
        ssql += "    order by fil.ds_filial,s.ds_sala ";

        cmd.CommandText = ssql;
        cmd.Connection = con;
        con.Open();
        SqlDataReader dr = cmd.ExecuteReader();

        while (dr.Read())
        {
            resources r = new resources();
            r.id = Convert.ToInt32(dr["cod_sala"]);
            r.title = "SALA " + dr["ds_sala"].ToString();
            r.building = dr["ds_filial"].ToString();
            List<children> childrens = new List<children>();

            SqlConnection conTerapeuta = new SqlConnection();
            conTerapeuta.ConnectionString = conexao.ToString();

            SqlCommand cmdTerapeuta = new SqlCommand();
            String ssqlTerepeuta = "";
            ssqlTerepeuta = @"select cod_terapeuta, nm_terapeuta from tb_terapeuta
                                        where 1=1 ";

            if (cod_terapeuta != "0")
            {
                ssqlTerepeuta += " and cod_terapeuta="+ cod_terapeuta;
            }

            cmdTerapeuta.CommandText = ssqlTerepeuta;
            cmdTerapeuta.Connection = conTerapeuta;
            conTerapeuta.Open();
            SqlDataReader drTerapeuta = cmdTerapeuta.ExecuteReader();
            while (drTerapeuta.Read())
            {
                children c = new children();
                c.id = Convert.ToInt32(drTerapeuta["cod_terapeuta"]);
                c.title = drTerapeuta["nm_terapeuta"].ToString();
                childrens.Add(c);
            }
            drTerapeuta.Close();
            conTerapeuta.Close();

            r.children = childrens;
            resources.Add(r);

        }





        con.Close();
        return Newtonsoft.Json.JsonConvert.SerializeObject(resources);

    }

    [WebMethod()]
    public static String MontaAtendimentos(String cod_filial, String cod_terapeuta)
    {
        String conexao = ConfigurationManager.ConnectionStrings["conexao"].ConnectionString;
        SqlConnection con = new SqlConnection();
        con.ConnectionString = conexao.ToString();

        SqlCommand cmd = new SqlCommand();

        String ssql = "";
        ssql = @"select cod_atendimento, cod_sala,cod_terapeuta,ds_atendimento,data_inicio + ' ' + hora_inicio dt_inicio, data_fim + ' ' + hora_fim dt_fim from(
                        select convert(varchar(20),dt_inicio,111) data_inicio, convert(varchar(20),dt_inicio,108) hora_inicio,
	                           convert(varchar(20),dt_fim,111) data_fim, convert(varchar(20),dt_fim,108) hora_fim, cod_terapeuta,cod_sala,ds_atendimento,cod_atendimento
                          from tb_atendimento where 1=1 ";

        if (cod_filial != "0")
        {
            ssql += " and cod_filial =" + cod_filial;
        }
        if (cod_terapeuta != "0")
        {
            ssql += " and cod_terapeuta =" + cod_terapeuta;
        }
        ssql += " ) tb_dados";


        
        cmd.CommandText = ssql;

        List<events> events = new List<events>();
        cmd.Connection = con;
        con.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        while (dr.Read())
        {

            events evento1 = new events();
            evento1.id = Convert.ToInt32(dr["cod_atendimento"]);
            evento1.resourceId = dr["cod_sala"].ToString() + "_" + dr["cod_terapeuta"].ToString();
            evento1.start = dr["dt_inicio"].ToString().Replace("/", "-");
            evento1.end = dr["dt_fim"].ToString().Replace("/", "-");
            evento1.title = dr["ds_atendimento"].ToString();

            events.Add(evento1);
        }

        dr.Close();
        con.Close();

        return Newtonsoft.Json.JsonConvert.SerializeObject(events);

    }

    [WebMethod()]
    public static List<Filial> BuscaFilial()
    {
        String conexao = ConfigurationManager.ConnectionStrings["conexao"].ConnectionString;
        SqlConnection con = new SqlConnection();
        con.ConnectionString = conexao.ToString();

        SqlCommand cmd = new SqlCommand();


        cmd.CommandText = @"select * from tb_filial";

        List<Filial> retorno = new List<Filial>();
        cmd.Connection = con;
        con.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        while (dr.Read())
        {

            Filial filial = new Filial();
            filial.cod_filial = Convert.ToInt32(dr["cod_filial"]);
            filial.ds_filial = dr["ds_filial"].ToString();
            retorno.Add(filial);
        }

        dr.Close();
        con.Close();

        return retorno;

    }

    [WebMethod()]
    public static List<Terapeuta> BuscaTerapeuta(int liberacao)
    {
        String conexao = ConfigurationManager.ConnectionStrings["conexao"].ConnectionString;
        SqlConnection con = new SqlConnection();
        con.ConnectionString = conexao.ToString();

        SqlCommand cmd = new SqlCommand();

        String ssql = "";
        ssql = @"select cod_terapeuta,nm_terapeuta from tb_terapeuta where 1=1 ";
        if (liberacao == 0)
        {
           ssql += " and cod_terapeuta = 1";
        }
        else
        {
            ssql += " UNION select  0,'Todos'order by cod_terapeuta";
        }
        cmd.CommandText = ssql;
        List<Terapeuta> retorno = new List<Terapeuta>();
        cmd.Connection = con;
        con.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        while (dr.Read())
        {

            Terapeuta terapeuta = new Terapeuta();
            terapeuta.cod_terapeuta = Convert.ToInt32(dr["cod_terapeuta"]);
            terapeuta.ds_terapueta = dr["nm_terapeuta"].ToString();
            retorno.Add(terapeuta);
        }

        dr.Close();
        con.Close();

        return retorno;

    }
}



public class events
{
    public int id { get; set; }
    public string resourceId { get; set; }
    public string start { get; set; }
    public string end { get; set; }
    public string title { get; set; }
}
public class resources
{
    public int id { get; set; }
    public string title { get; set; }
    public string building { get; set; }
    public List<children> children { get; set; }
}
public class children
{
    public int id { get; set; }
    public string title { get; set; }
}

public class Filial
{
    public int cod_filial { get; set; }
    public string ds_filial { get; set; }
}
public class Sala
{
    public int cod_sala { get; set; }
    public string ds_sala { get; set; }
}

public class Terapeuta
{
    public int cod_terapeuta { get; set; }
    public string ds_terapueta { get; set; }
}
public class Atendimento
{
    public int cod_atendimento { get; set; }
    public DateTime dt_inicio { get; set; }
    public DateTime dt_fim { get; set; }
}
