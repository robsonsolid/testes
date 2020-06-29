﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

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
    <script src='fullcalendar-scheduler-4.4.2/packages/bootstrap/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/interaction/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/daygrid/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/timegrid/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages/list/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/timeline/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/resource-common/main.js'></script>
    <script src='fullcalendar-scheduler-4.4.2/packages-premium/resource-timeline/main.js'></script>
    <script src="fullcalendar-scheduler-4.4.2/examples/js/theme-chooser.js"></script>

    <script>

        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            var calendar;

            initThemeChooser({

                init: function (themeSystem) {
                    calendar = new FullCalendar.Calendar(calendarEl, {
                        plugins: ['bootstrap', 'interaction', 'dayGrid', 'timeGrid', 'list', 'resourceTimeline'],
                        themeSystem: themeSystem,
                        now: '2020-05-07',
                        editable: false, // enable draggable events
                        aspectRatio: 1.8,
                        scrollTime: '00:00', // undo default 6am scrollTime
                        header: {
                            left: 'today prev,next',
                            center: 'title',
                            right: 'resourceTimelineDay,resourceTimelineThreeDays,timeGridWeek,dayGridMonth,listWeek'
                        },
                        defaultView: 'resourceTimelineDay',
                        views: {
                            resourceTimelineThreeDays: {
                                type: 'resourceTimeline',
                                duration: { days: 3 },
                                buttonText: '3 days'
                            }
                        },
                        resourceLabelText: 'Rooms',
                        resources: [
                            { id: 'a', title: 'Auditorium A' },
                            { id: 'b', title: 'Auditorium B', eventColor: 'green' },
                            { id: 'c', title: 'Auditorium C', eventColor: 'orange' },
                            {
                                id: 'd', title: 'Auditorium D', children: [
                                    { id: 'd1', title: 'Room D1' },
                                    { id: 'd2', title: 'Room D2' }
                                ]
                            },
                            { id: 'e', title: 'Auditorium E' },
                            { id: 'f', title: 'Auditorium F', eventColor: 'red' },
                            { id: 'g', title: 'Auditorium G' },
                            { id: 'h', title: 'Auditorium H' },
                            { id: 'i', title: 'Auditorium I' },
                            { id: 'j', title: 'Auditorium J' },
                            { id: 'k', title: 'Auditorium K' },
                            { id: 'l', title: 'Auditorium L' },
                            { id: 'm', title: 'Auditorium M' },
                            { id: 'n', title: 'Auditorium N' },
                            { id: 'o', title: 'Auditorium O' },
                            { id: 'p', title: 'Auditorium P' },
                            { id: 'q', title: 'Auditorium Q' },
                            { id: 'r', title: 'Auditorium R' },
                            { id: 's', title: 'Auditorium S' },
                            { id: 't', title: 'Auditorium T' },
                            { id: 'u', title: 'Auditorium U' },
                            { id: 'v', title: 'Auditorium V' },
                            { id: 'w', title: 'Auditorium W' },
                            { id: 'x', title: 'Auditorium X' },
                            { id: 'y', title: 'Auditorium Y' },
                            { id: 'z', title: 'Auditorium Z' }
                        ],
                        events: [
                            { id: '1', resourceId: 'b', start: '2020-05-07T02:00:00', end: '2020-05-07T07:00:00', title: 'event 1' },
                            { id: '2', resourceId: 'c', start: '2020-05-07T05:00:00', end: '2020-05-07T22:00:00', title: 'event 2' },
                            { id: '3', resourceId: 'd2', start: '2020-05-06', end: '2020-05-08', title: 'event 3' },
                            { id: '4', resourceId: 'e', start: '2020-05-07T03:00:00', end: '2020-05-07T08:00:00', title: 'event 4' },
                            { id: '5', resourceId: 'f', start: '2020-05-07T00:30:00', end: '2020-05-07T02:30:00', title: 'event 5' }
                        ],
                        eventClick: function (info) {
                            alert('Event: ' + info.event.title);
                            alert('Event: ' + info.event.id);

                            alert('Coordinates: ' + info.jsEvent.pageX + ',' + info.jsEvent.pageY);
                            alert('View: ' + info.view.type);
                        },
                        dateClick: function (info) {
                            alert('Date: ' + info.dateStr);                            
                            alert('Resource ID: ' + info.resource.id);
                            
                        }
                    });
                    calendar.render();
                },


                change: function (themeSystem) {
                    calendar.setOption('themeSystem', themeSystem);
                }

            });

        });

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
<body>

    <div id='top'>

        <div class='left'>

            <div id='theme-system-selector' class='selector'>
                Theme System:

       

                <select>
                    <option value='bootstrap' selected>Bootstrap 4</option>
                    <option value='standard'>unthemed</option>
                </select>
            </div>

            <div data-theme-system="bootstrap" class='selector' style='display: none'>
                Theme Name:

       

                <select>
                    <option value='' selected>Default</option>
                    <option value='cerulean'>Cerulean</option>
                    <option value='cosmo'>Cosmo</option>
                    <option value='cyborg'>Cyborg</option>
                    <option value='darkly'>Darkly</option>
                    <option value='flatly'>Flatly</option>
                    <option value='journal'>Journal</option>
                    <option value='litera'>Litera</option>
                    <option value='lumen'>Lumen</option>
                    <option value='lux'>Lux</option>
                    <option value='materia'>Materia</option>
                    <option value='minty'>Minty</option>
                    <option value='pulse'>Pulse</option>
                    <option value='sandstone'>Sandstone</option>
                    <option value='simplex'>Simplex</option>
                    <option value='sketchy'>Sketchy</option>
                    <option value='slate'>Slate</option>
                    <option value='solar'>Solar</option>
                    <option value='spacelab'>Spacelab</option>
                    <option value='superhero'>Superhero</option>
                    <option value='united'>United</option>
                    <option value='yeti'>Yeti</option>
                </select>
            </div>

            <span id='loading' style='display: none'>loading theme...</span>

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

    <div id='calendar'></div>

</body>
</html>
