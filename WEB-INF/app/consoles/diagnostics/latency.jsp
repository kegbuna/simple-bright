<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/app/framework/consoleInitialization.jspf" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%
    LinkedHashMap<String,Object> latency = (LinkedHashMap<String,Object>)request.getAttribute("latency");
%>
<tag:application>
    <jsp:attribute name="title">Kinetic | Latency</jsp:attribute>
    <jsp:attribute name="navigationCategory">Diagnostics</jsp:attribute>
    <jsp:attribute name="content">
    <section class="content">
    <div class="container-fluid main-inner">
    <div class="row">
        <%-- LEFT SIDEBAR --%>
        <div class="col-xs-2 sidebar">
            <jsp:include page="/WEB-INF/app/consoles/diagnostics/_leftNavigation.jsp">
                <jsp:param name="navigationItem" value="Latency"/>
            </jsp:include>
        </div>
        <div class="col-xs-10">
            <div class="row">
                <%-- CENTER CONTENT --%>
                <div class="col-xs-9">
                    <%-- PAGE HEADER --%>
                    <div class="page-header">
                        <h3>
                            Latency
                        </h3>
                    </div>
                    <%-- SESSION MESSAGE --%>
                    <%@include file="/WEB-INF/app/interface/sessionMessage.jspf" %>
                    
                    <%-- PAGE CONTENT --%>
                    <div class="tab-content">
                        <div id="container"></div>
                        
                        
                    </div>
                </div>
                <%-- RIGHT SIDEBAR --%>
                <div class="col-xs-3 sidebar pull-right">
                    <jsp:include page="/WEB-INF/app/consoles/_shared/help.jsp">
                        <jsp:param name="helpType" value="Diagnostic Consoles" />
                        <jsp:param name="helpUrl" value="http://help.kineticdata.com/ksr52/consoles/diagnostics" />
                    </jsp:include>
                    <jsp:include page="/WEB-INF/app/consoles/diagnostics/_latencyHelpText.jsp"/>
                </div>
            </div>
        </div>
    </div>
    </div>
    </section>
    <script src="<%=request.getContextPath()%>/app/thirdparty/highcharts/highcharts.min.js"></script>
    <script type="text/javascript">
        $(function() {
            var initialData = <%= JsonUtils.toJsonString(latency) %>
            var index = _.size(initialData);
        
            var poll = function(callback) {
                KineticSr.app.ajax({
                    url:  KineticSr.app.contextPath+'/app/diagnostics/latency',
                    type: 'GET',
                    success: function(data) {
                        callback(data);
                        // Call the poll function 1 second from now
                        setTimeout(function() {poll(callback);}, 1000);
                    }
                });
            };
        
            $('#container').highcharts({
                title: {
                    text: null
                },
                credits: { enabled: false },
                exporting: { enabled: false },    
                chart: {
                    type: 'spline',
                    animation: Highcharts.svg, // don't animate in old IE
                    marginRight: 10,
                    marginBottom: 60,
                    events: {
                        load: function () {
                            var arsSeries = this.series[0];
                            var databaseSeries = this.series[1];
                            setTimeout(function() {
                                poll(function (data) {
                                    index += 1;
                                    arsSeries.addPoint([index, data.latency.ars[0]], false, index >= 10);
                                    databaseSeries.addPoint([index, data.latency.database[0]], true, index >= 10);
                                })
                            }, 1000);
                        }
                    }
                },
                xAxis: {
                    title: {
                        text: null
                    },
                    labels: {
                        enabled: false
                    }
                },
                yAxis: {
                    title: {
                        text: 'Duration (ms)'
                    },
                    allowDecimals: false,
                    min: 0,
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
                tooltip: {
                    enabled: false
                },
                legend: {
                    align: "right",
                    borderWidth: 0,
                    floating: true,
                    labelFormatter: function() {
                        return '<span style="color: '+this.color+'">'+ this.name + '</span>'; 
                    },
                    layout: 'vertical',
                    useHTML: true,
                    verticalAlign: "bottom",
                    y: 0
                },
                plotOptions: {
                    spline: {
                        events: {
                            legendItemClick: function() { return false; }
                        },
                        states: {
                            hover: {
                                enabled: false,
                                lineWidthPlus: 0
                            }
                        }
                    }
                },
                series: [
                    {
                        name: 'App Server <i class="fa fa-arrows-h"></i> ARS Server',
                        data: (function () {
                            var data = [];
                            for (var x = 0; x < index; x += 1) {
                                data.push({
                                    x: x,
                                    y: initialData.ars[x]
                                });
                            }
                            return data;
                        }())
                    },
                    {
                        name: 'App Server <i class="fa fa-arrows-h"></i> ARS Server <i class="fa fa-arrows-h"></i> Database Server',
                        data: (function () {
                            var data = [];
                            for (var x = 0; x < index; x += 1) {
                                data.push({
                                    x: x,
                                    y: initialData.database[x]
                                });
                            }
                            return data;
                        }())
                    }
                ]
            });
        });
    </script>
    </jsp:attribute>
</tag:application>  