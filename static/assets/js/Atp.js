var host = 'http://192.168.5.142'


function project(res) {
    if (res.code == 200) {
        $('#dataTables-example').dataTable().fnClearTable();//清空数据.fnClearTable();//清空数据
        $('#dataTables-example').dataTable().fnDestroy(); //还原初始化了的datatable
        var projects = res.data.projects;
        for (var i = 0; i < projects.length; i++) {
            var tr = ''
            tr += '<tr>';
            tr += '<td class="center">' + (i + 1) + '</td>'
            tr += '<td class="center">' + projects[i].name + '</td>'
            tr += '<td class="center">' + projects[i].creatorName + '</td>'
            tr += '<td class="center">' + projects[i].createTime + '</td>'
            tr += '<td class="center">' + projects[i].environments.length + '</td>'
            tr += '<td class="center">' + projects[i].remark + '</td>'
            tr += '<td class="center">'
            tr += '<a href="javascript:void(0);" class="pointer"  onclick="editProject(' + projects[i].id + ')">编辑</a>'
            tr += ' - '
            tr += '<a  class="pointer" href="2项目管理--环境配置.html?pid=' + projects[i].id + '">配置</a>'
            tr += ' - '
            tr += '<a href="javascript:void(0);" class="pointer"  onclick="del(\'project\',' + projects[i].id + ')">删除</a>'
            tr += '</td></tr>';
            $(".js_table").append(tr)
        }
        dataTableBuid()
    } else {

    }
}

function init(model, callback) {
    var data = JSON.stringify({"pageSize": 999999999})
    $.ajax({
        url: host + "/api/v1/" + model,
        type: 'post',
        dataType: 'json',
        data: data,
        success: callback
    })
}


function dataTableBuid() {
    $('#dataTables-example').dataTable({
        "bRetrieve": true,
        "bPaginate": true,  //是否显示分页
        "bSort": true,     //是否支持排序功能
        "bAutoWidth": false, //自动宽度
        "serverSide": false,
        "pageLength": 10,
        "sPaginationType": "full_numbers", //分页
        "oLanguage": {      //多语言配置
            "sLengthMenu": "每页显示 10 条记录",
            "sZeroRecords": "对不起，查询不到任何相关数据",
            "sInfo": "当前显示 _START_ 到 _END_ 条，共 _TOTAL_ 条记录",
            "sInfoEmtpy": "找不到相关数据",
            "sInfoFiltered": "数据表中共为 _MAX_ 条记录)",
            "sProcessing": "正在加载中...",
            "oPaginate": {
                "sFirst": "第一页",
                "sPrevious": " 上一页 ",
                "sNext": " 下一页 ",
                "sLast": " 最后一页 "
            }
        },
    });
}

function create(model) {
    var name, remark;
    name = $("#projectName").val();
    remark = $("#remark").val();
    var data = JSON.stringify({"name": name, "remark": remark});
    $.ajax({
        url: host + "/api/v1/" + model + "/create",
        type: 'post',
        dataType: 'json',
        data: data,
        success: function (res) {
            if (res.code == 200) {
                $("#remark").val("");
                $("#projectName").val("");
                $("#newProject").modal("hide");
                setTimeout(function () {
                    init("project", project);
                }, 1000)
            } else {
                $("#message").html("");
                $("#message").html(res.message);
            }
        }
    })
}

function editProject(id) {
    $("#myModalLabel").html("编辑项目");
    $("#newProject").modal("show");
    $("#save").attr("onclick", "edit(" + id + ")");
    $.ajax({
        url: host + "/api/v1/project/" + id,
        type: 'post',
        dataType: 'json',
        success: function (res) {
            if (res.code == 200) {
                $("#projectName").val(res.data.name);
                $("#remark").val(res.data.remark);
            } else {
                $("#projectName").val('');
                $("#remark").val('');
                $("#message").html("");
                $("#message").html(res.message);
            }
        }
    })
}

function edit(id) {
    var name, remark;
    name = $("#projectName").val();
    remark = $("#remark").val();
    var data = JSON.stringify({"name": name, "remark": remark});
    $.ajax({
        url: host + "/api/v1/project/edit/" + id,
        type: 'post',
        dataType: 'json',
        data: data,
        success: function (res) {
            if (res.code == 200) {
                $("#newProject").modal("hide");
                $("#save").attr("onclick", "create('project')");
                $("#myModalLabel").html("新建项目");
                $("#projectName").val("");
                $("#remark").val("");
                setTimeout(function () {
                    init("project", project);
                }, 1000)
            } else {
                $("#message").html("");
                $("#message").html(res.message);
            }
        }
    })
}

function config(id) {
    // $("#projectName").val(id)
}

function del(model, id) {
    $.ajax({
        url: host + "/api/v1/" + model + "/delete/" + id,
        type: 'post',
        dataType: 'json',
        success: function (res) {
            if (res.code == 200) {
                $("#newProject").modal("hide");
                $("#save").attr("onclick", "create('project')");
                $("#myModalLabel").html("新建项目");
                $("#projectName").val("");
                $("#remark").val("");
                setTimeout(function () {
                    init("project", project);
                }, 1000)
            } else {
                $("#message").html("");
                $("#message").html(res.message);
            }
        }
    })
}
