<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Agenda.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset='utf-8' />

    <link href='fullcalendar-scheduler-4.4.2/packages/core/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages/bootstrap/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages/daygrid/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages/timegrid/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages/list/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages-premium/timeline/main.css' rel='stylesheet' />
    <link href='fullcalendar-scheduler-4.4.2/packages-premium/resource-timeline/main.css' rel='stylesheet' />
    
    <script src='fullcalendar-scheduler-4.4.2/packages/core/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/core/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/bootstrap/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/interaction/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/daygrid/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/timegrid/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/list/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/timeline/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/resource-common/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/resource-timeline/main.js'></script>
    <script src="fullcalendar-scheduler-4.4.2/examples/js/theme-chooser.js"></script>
    <script src="jquery-1.10.2.js"></script>

    <script>
   
        var calendar;
        var calendarEl;

        function filtrar(primeira) {



            if (primeira == 'N') {
                calendar.destroy();
            }
           


            calendarEl = document.getElementById('calendar');
            calendar = new FullCalendar.Calendar(calendarEl, {
                
                locale: 'pt-br',
                plugins: ['bootstrap', 'interaction', 'dayGrid', 'timeGrid', 'list', 'resourceTimeline'],
                now: '2020-06-26',
                editable: false, // enable draggable events
                aspectRatio: 1.8,
                scrollTime: '00:00', // undo default 6am scrollTime
               themeSystem: 'bootstrap4',
                header: {
                    left: 'today prev,next',
                    center: 'title',
                    right: 'resourceTimelineDay,resourceTimelineThreeDays,timeGridWeek,dayGridMonth,listWeek'

                },

                buttonText: {
                    today: 'Hoje',
                    prev: 'Anterior',
                    next: 'Próximo',
                    month: 'Mês',
                    week: 'Semana',
                    day: 'Dia',
                    list: 'Lista de Consultas'
                },
               
                defaultView: 'resourceTimelineDay',
                views: {
                    resourceTimelineThreeDays: {
                        type: 'resourceTimeline',
                        duration: { days: 3 },
                        buttonText: '3 Dias'
                    }
                },
                resourcesInitiallyExpanded: false,
                resourceLabelText: 'Salas/Terapeutas',
                resourceGroupField: 'building',
                resources: montaTable(),
                events: MontaAtendimentos(),
                failure: function () {
                    alert('there was an error while fetching events!');
                },
                eventClick: function (info) {
                    alert('Consulta: ' + info.event.title);
              
                },
                dateClick: function (info) {
                    alert('Date: ' + info.dateStr);
                    alert('Resource ID: ' + info.resource.id);
                    

                }
            });
            calendar.render();

        }

        function montaTable() {
                 var resources = [];
        
            cod_filial = $("#ddlUnidade").val();
            cod_terapeuta = $("#ddlTerapeuta").val();


            $.ajax({
                type: 'POST',

                url: 'Agenda.aspx/MontaSalaTerapeuta',
                data: "{'cod_filial':'" + cod_filial.toString() + "',cod_terapeuta:'" + cod_terapeuta.toString() + "'}",
                async: false,
                contentType: 'application/json; charset=utf-8',
                dataType: 'JSON',
                success: function (data) {


                    //console.log(JSON.parse(data.d));
                    var obj = JSON.parse(data.d);

                    obj.forEach(function (item, indice, array) {

                        resources.push({
                            id: item.id,
                            building: item.building,
                            title: item.title,
                            children: retornaTerapeutas(item.id, item.children)


                        });


                    });

                },

                error: function (request, status, error) {
                    alert(request.responseText);
                }
            });

            return resources
        }
        function retornaTerapeutas(cod_sala, itens) {
            var terapeutas = [];
            itens.forEach(function (item2, indice, array) {

                terapeutas.push({
                    id: cod_sala + "_" + item2.id,
                    title: item2.title

                });

            })

            return terapeutas;
        }
        function MontaAtendimentos() {
            cod_filial = $("#ddlUnidade").val();
            cod_terapeuta = $("#ddlTerapeuta").val();
                 
        var events = [];

            $.ajax({
                type: 'POST',

                url: 'Agenda.aspx/MontaAtendimentos',
                data: "{'cod_filial':'" + cod_filial.toString() + "',cod_terapeuta:'" + cod_terapeuta.toString() + "'}",
                async: false,
                contentType: 'application/json; charset=utf-8',
                dataType: 'JSON',
                success: function (data) {
                    //console.log(JSON.parse(data.d));
                    var obj = JSON.parse(data.d);

                    obj.forEach(function (item, indice, array) {

                        events.push({
                            id: item.id,
                            resourceId: item.resourceId,
                            title: item.title,
                            start: item.start,
                            end: item.end



                        });


                    });

                },

                error: function (request, status, error) {
                    alert(request.responseText);
                }
            });
            return events;
        }

        function BuscaFilialTerapeuta() {


            BuscaFilial();
            BuscaTerapeuta();
            filtrar('S');


        }
        function BuscaFilial() {
            $.ajax({
                type: 'POST',

                url: 'Agenda.aspx/BuscaFilial',
                async: false,
                contentType: 'application/json; charset=utf-8',
                dataType: 'JSON',
                success: function (data) {
                    //console.log(JSON.parse(data.d));
                    $("#ddlUnidade").empty();
                    $("#ddlUnidade").append('<option value="0">Todos...</option>');
                    $.each(data.d, function (index, element) {
                        console.log(element.id);
                        $("#ddlUnidade").append('<option value="' + element.cod_filial + '">' + element.ds_filial + '</option>');
                    });

                },

                error: function (request, status, error) {
                    alert(request.responseText);
                }
            });
        }
        function BuscaTerapeuta() {
            var liberacao = $("#hdnLiberacao").val();
            $.ajax({
                type: 'POST',

                url: 'Agenda.aspx/BuscaTerapeuta',
                data: "{'liberacao':" + liberacao + "}",
                async: false,
                contentType: 'application/json; charset=utf-8',
                dataType: 'JSON',
                success: function (data) {
                    //console.log(JSON.parse(data.d));
                    $("#ddlTerapeuta").empty();
                    //$("#ddlTerapeuta").append('<option value="0">Selecione...</option>');
                    $.each(data.d, function (index, element) {
                        console.log(element.id);
                        $("#ddlTerapeuta").append('<option value="' + element.cod_terapeuta + '">' + element.ds_terapueta + '</option>');
                    });

                },

                error: function (request, status, error) {
                    alert(request.responseText);
                }
            });
        }
    </script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-size: 14px;
        }

        #top,
        #calendar.fc-unthemed {
            font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
        }

        #top {
            background: #eee;
            border-bottom: 1px solid #ddd;
            padding: 0 10px;
            line-height: 40px;
            font-size: 12px;
            color: #000;
        }

            #top .selector {
                display: inline-block;
                margin-right: 10px;
            }

            #top select {
                font: inherit; /* mock what Boostrap does, don't compete  */
            }

        .left {
            float: left
        }

        .right {
            float: right
        }

        .clear {
            clear: both
        }

        #calendar {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 10px;
        }
    </style>
</head>
<body onload="BuscaFilialTerapeuta()">
    <form runat="server">
    <div id='top'>
        <asp:HiddenField ID="hdnLiberacao" runat="server" />
        <div class='left'>
            Unidade:    
            <select id="ddlUnidade">
            </select>
            Terapeuta: 
            <select id="ddlTerapeuta">
                <option></option>
            </select>
            <input id="btnFiltro" name="btnFiltro" value="Filtar" type="button" onclick="filtrar('N')" />

        </div>

        <div class='right'>
            <span class='credits' data-credit-id='bootstrap-standard' style='display: none'>
                <a href='https://getbootstrap.com/docs/3.3/' target='_blank'>Theme by Bootstrap</a>
            </span>
            <span class='credits' data-credit-id='bootstrap-custom' style='display: none'>
                <a href='https://bootswatch.com/' target='_blank'>Theme by Bootswatch</a>
            </span>
        </div>

        <div class='clear'></div>
    </div>

    <div id='calendar' style="height: 100%"></div>
        </form>
</body>
</html>
