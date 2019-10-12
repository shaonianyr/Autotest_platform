#coding:utf-8
from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.contrib.auth.decorators import login_required
from django.contrib import auth
from django.contrib.auth import authenticate,login
from django.shortcuts import render
from django.contrib import messages
import json
import os
import pymysql
import time
from django.core.paginator import  Paginator, EmptyPage, PageNotAnInteger


# Create your views here.
def login(request):
    if request.POST:
        username = password = ''
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = auth.authenticate(username=username,password=password)  #认证给出的用户名和密码
        if user is not None and user.is_active:    #判断用户名和密码是否有效
            auth.login(request, user)
            request.session['user'] = username  #跨请求的保持user参数
            response = HttpResponseRedirect('/admin/index')
            return response
        else:
            messages.add_message(request, messages.WARNING, '账户或者密码错误，请检查')
            return render(request, 'page/1登录.html')
    
    return render(request, 'page/1登录.html')

@login_required
def logout(request):
    auth.logout(request)
    return render(request, 'page/1登录.htm')


@login_required
def index(request):
    return render(request, "page/首页.html")


@login_required
def project(request):
    return render(request, "page/2项目管理.html")


@login_required
def project_config(request, project_id):
    from Product.models import Project
    from Autotest_platform.helper.util import get_model
    p = get_model(Project, id=project_id)
    name = p.name if p else ""
    return render(request, "page/2项目管理--环境配置.html", {"projectId": project_id, "projectName": name})


@login_required
def page(request):
    return render(request, "page/3页面管理.html")


@login_required
def element(request):
    return render(request, "page/4页面元素.html")


@login_required
def keyword(request):
    return render(request, "page/5关键字库.html")


@login_required
def keyword_create(request):
    return render(request, "page/5-1新建关键字.html")


@login_required
def keyword_edit(request, keyword_id):
    from Product.models import Keyword, Project
    from Autotest_platform.helper.util import get_model
    kw = get_model(Keyword, id=keyword_id)
    projectId = kw.projectId if kw else 0
    p = get_model(Project, id=projectId)
    projectName = p.name if projectId > 0 and p else "通用"
    keywordName = kw.name if kw else ""
    return render(request, "page/5-2编辑关键字.html",
                  {"id": projectId, "projectName": projectName, "keywordId": keyword_id, "keywordName": keywordName})


@login_required
def testcase(request):
    return render(request, "page/6测试用例.html")


@login_required
def testcase_create(request):
    return render(request, "page/6-1新建测试用例.html")


@login_required
def testcase_edit(request, testcase_id):
    return render(request, "page/6-1编辑测试用例.html", {"testcaseId": testcase_id})


@login_required
def result(request):
    return render(request, "page/7测试结果.html")


@login_required
def result_see(request, result_id):
    return render(request, "page/7-1查看测试结果.html", {"id": result_id})


@login_required
def task(request):
    return render(request, "page/9任务管理.html")


@login_required
def loginConfig(request):
    return render(request, "page/8登录配置.html")


@login_required
def loginConfig_create(request):
    return render(request, "page/8-1新建登录配置.html")


@login_required
def loginConfig_edit(request, login_id):
    return render(request, "page/8-1编辑登录配置.html", {"id": login_id})
