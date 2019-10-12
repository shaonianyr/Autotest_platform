import django.utils.timezone as timezone
from django.core.exceptions import ValidationError
from django.forms.models import model_to_dict

from MiDuoTester.helper.Http import *
from MiDuoTester.helper.util import *
from Product.models import Element as element
from Product.models import Environment as environment
from Product.models import Keyword as keyword
from Product.models import Page as page
from Product.models import Project as project
from Product.models import Result, Task, LoginConfig, EnvironmentLogin, User as user
from Product.models import TestCase as testcase, Browser
from .tasks import SplitTask


# Create your views here.
class User:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        u = user()
        u.userName = parameter.get("userName", "")
        u.password = parameter.get("password", "")
        u.email = parameter.get("email", "")
        try:
            u.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        if user.objects.filter(userName__iexact=u.userName):
            return JsonResponse.BadRequest("该账号已存在,请修改后重试")
        u.password = md5(u.password)
        try:
            u.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    @check_login
    def edit(request):
        u = get_model(user, id=request.session.get(Session.USER, 0))
        if not u:
            return JsonResponse(404, '所登陆的账号无法找到')
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        oldPassword = parameter.get("oldPassword", "")
        newPassword = parameter.get("newPassword", "")
        u.email = parameter.get("email", u.email)
        u.nickname = parameter.get("nickname", u.nickname)
        if md5(oldPassword) != u.password:
            return JsonResponse.BadRequest('旧密码错误')
        u.password = newPassword
        try:
            u.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        if user.objects.filter(userName__iexact=u.userName).exclude(id=u.id):
            return JsonResponse.BadRequest("该账号已存在,请修改后重试")
        u.password = md5(u.password)
        try:
            u.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        nickname = parameter.get("nickname") if parameter.get("nickname", "") else ""
        userName = parameter.get("userName") if parameter.get("userName", "") else ""
        try:
            users = get_model(user, get=False, createTime__lt=end_time, createTime__gt=start_time,
                              nickname__contains=nickname, userName__contains=userName)
            total = len(users)
        except:
            return JsonResponse(400, "时间参数错误")
        users = users[(page_index - 1) * page_size:page_index * page_size]
        u_list = list()
        for u in users:
            dic = model_to_dict(u, ["id", 'userName', 'nickname', 'email'])
            dic["createTime"] = u.createTime.strftime('%Y-%m-%d %H:%M:%S')
            u_list.append(dic)
        result = dict()
        result["total"] = total
        result["users"] = u_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, user_id):
        u = get_model(user, id=user_id)
        if not u:
            return JsonResponse.BadRequest("该用户不存在")
        result = model_to_dict(u, ["id", 'userName', 'nickname', 'email'])
        result["createTime"] = u.createTime.strftime('%Y-%m-%d %H:%M:%S')
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    @post
    def login(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        userName = parameter.get("userName", "")
        password = parameter.get("password", "")
        try:
            u = user.objects.get(userName__iexact=userName, password__exact=md5(password))
        except:
            return JsonResponse(400, '账号或密码错误')
        request.session[Session.USER] = u.id
        return JsonResponse.OK()

    @staticmethod
    @check_login
    def checkLogin(request):
        u = get_model(user, id=request.session.get(Session.USER, 0))
        if not u:
            return JsonResponse(400, '未找到登陆信息')
        else:
            return JsonResponse(200, 'ok', model_to_dict(u, ["id", "userName", 'nickname', 'email']))

    @staticmethod
    @check_login
    def logout(request):
        u = get_model(user, id=request.session.get(Session.USER, 0))
        if not u:
            return JsonResponse(400, '未找到登陆信息')
        else:
            del request.session[Session.USER]
        return JsonResponse.OK()


class Project:
    @staticmethod
    # @check_login
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # u = get_model(user, id=request.session.get(Session.USER, 0))
        # if not u:
        #     return JsonResponse(400, '未找到登陆信息')
        p = project()
        p.creator = 1
        # p.creator = u.id
        p.name = parameter.get("name", "")
        p.remark = parameter.get("remark", "")
        try:
            p.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        p.name = p.name.strip()
        if project.objects.filter(name__exact=p.name):
            return JsonResponse.BadRequest("项目已存在,请修改后重试")
        try:
            p.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, project_id):
        p = get_model(project, id=project_id)
        if not p:
            return JsonResponse(404, "该项目不存在")
        pages = page.objects.filter(projectId=p.id)
        if pages:
            return JsonResponse(400, "删除失败，请先删除项目下的所有页面")
        keywords = keyword.objects.filter(projectId=p.id)
        if keywords:
            return JsonResponse(400, "删除失败，请先删除项目下的所有关键字")
        loginConfigs = LoginConfig.objects.filter(projectId=p.id)
        if loginConfigs:
            return JsonResponse(400, "删除失败，请先删除项目下的所有登录配置")
        try:
            environment.objects.filter(projectId=p.id).delete()
            p.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse(200, "ok")

    @staticmethod
    @post
    def edit(request, project_id):
        # 获取项目
        p = get_model(project, id=project_id)
        if not p:
            return JsonResponse.BadRequest("该项目不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # 判断参数有效性
        p.name = parameter.get("name", "")
        p.remark = parameter.get("remark", "")
        try:
            p.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        # 判断重复
        p.name = p.name.strip()
        if project.objects.filter(name__exact=p.name).exclude(id=p.id):
            return JsonResponse.BadRequest("项目已存在,请修改后重试")
        # 保存
        try:
            p.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        name = parameter.get("name") if parameter.get("name", "") else ""
        try:
            projects = project.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                              name__contains=name).order_by("-createTime")
            total = len(projects)
        except:
            return JsonResponse(400, "时间参数错误")
        projects = projects[(page_index - 1) * page_size:page_index * page_size]
        project_list = list()
        for p in projects:
            dic = model_to_dict(p, ["id", 'name', 'creator', 'remark'])
            dic["createTime"] = p.createTime.strftime('%Y-%m-%d %H:%M:%S')
            u = user.objects.get(id=p.creator)
            dic["creatorName"] = u.nickname if u.nickname else u.userName
            es = get_model(environment, False, projectId=p.id)
            e_list = list()
            for e in es:
                e_dic = model_to_dict(e, ["id", "name", "host", "remark"])
                e_list.append(e_dic)
            dic["environments"] = e_list
            project_list.append(dic)
        result = dict()
        result["total"] = total
        result["projects"] = project_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, project_id):
        p = get_model(project, id=project_id)
        if not p:
            return JsonResponse.BadRequest("该项目不存在")
        result = model_to_dict(p, ["id", 'name', 'creator', 'remark'])
        result["createTime"] = p.createTime.strftime('%Y-%m-%d %H:%M:%S')
        es = get_model(environment, False, projectId=p.id)
        e_list = list()
        for e in es:
            e_dic = model_to_dict(e, ["id", "name", "host", "remark"])
            e_list.append(e_dic)
        result["environments"] = e_list
        return JsonResponse.OK(message="ok", data=result)


class Environment:
    @staticmethod
    @post
    def create(request):
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        e = environment()
        e.projectId = parameter.get("projectId", 0)
        e.name = parameter.get("name", "")
        e.host = parameter.get("host", "")
        e.remark = parameter.get("remark", "")
        try:
            e.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        e.name = e.name.strip()
        if environment.objects.filter(name__exact=e.name, projectId=e.projectId):
            return JsonResponse.BadRequest("该环境已存在,请修改后重试")
        try:
            e.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, environment_id):
        e = get_model(environment, id=environment_id)
        if not e:
            return JsonResponse(404, "该环境不存在")
        try:
            EnvironmentLogin.objects.filter(environmentId=e.id).delete()
            e.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, environment_id):
        # 获取项目
        e = get_model(environment, id=environment_id)
        if not e:
            return JsonResponse(404, "该环境不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # 判断参数有效性
        e.name = parameter.get("name", e.name)
        e.host = parameter.get("host", e.host)
        e.remark = parameter.get("remark", e.remark)
        try:
            e.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        # 判断重复
        e.name = e.name.strip()
        if environment.objects.filter(name__exact=e.name, projectId=e.projectId).exclude(id=e.id):
            return JsonResponse.BadRequest("项目已存在该环境,请修改后重试")
        # 保存
        try:
            e.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        name = parameter.get("name") if parameter.get("name", "") else ""
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() else 0
        try:
            environments = environment.objects.filter(name__contains=name, projectId=projectId).order_by("-id")
            total = len(environments)
        except:
            return JsonResponse(400, "时间参数错误")
        environments = environments[(page_index - 1) * page_size:page_index * page_size]
        environments_list = list()
        for e in environments:
            environments_list.append(model_to_dict(e, ["id", "projectId", 'name', 'host', 'remark']))
        result = dict()
        result["total"] = total
        result["environments"] = environments_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, environment_id):
        e = get_model(environment, id=environment_id)
        if not e:
            return JsonResponse.BadRequest("该环境不存在")
        result = model_to_dict(e, ["id", 'projectId', 'name', 'host', 'remark'])
        return JsonResponse.OK(message="ok", data=result)


class Page:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        p = page()
        p.name = parameter.get("name", "")
        p.remark = parameter.get("remark", "")
        p.projectId = parameter.get("projectId", 0)
        try:
            p.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        p.name = p.name.strip()
        if page.objects.filter(name__exact=p.name, projectId=p.projectId):
            return JsonResponse.BadRequest("项目已存在该页面,请修改后重试")
        try:
            p.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, page_id):
        p = get_model(page, id=page_id)
        if not p:
            return JsonResponse(404, "该页面不存在")
        es = element.objects.filter(pageId=page_id)
        if es:
            return JsonResponse(400, "该页面已关联元素，请删除元素后重试")
        try:
            p.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse(200, "ok")

    @staticmethod
    @post
    def edit(request, page_id):
        # 获取项目
        p = get_model(page, id=page_id)
        if not p:
            return JsonResponse(404, "该页面不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse(500, "json格式错误")
        # 判断参数有效性
        p.name = parameter.get("name", "")
        p.remark = parameter.get("remark", "")
        # p.projectId = parameter.get("projectId", 0)
        try:
            p.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        p.name = p.name.strip()
        # 判断重复
        if page.objects.filter(name__exact=p.name, projectId=p.projectId).exclude(id=p.id):
            return JsonResponse.BadRequest("项目已存在该页面,请修改后重试")
        # 保存
        try:
            p.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse(500, "json格式错误")
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() and int(projectId) > 0 else 0
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        name = parameter.get("name") if parameter.get("name", "") else ""
        try:
            pages = page.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                        name__contains=name).order_by("-createTime")
            if projectId:
                pages = pages.filter(projectId=projectId)
            total = len(pages)
        except:
            return JsonResponse(400, "时间参数错误")
        pages = pages[(page_index - 1) * page_size:page_index * page_size]
        page_list = list()
        for p in pages:
            dic = model_to_dict(p, ["id", "projectId", 'name', 'remark'])
            dic["createTime"] = p.createTime.strftime('%Y-%m-%d %H:%M:%S')
            dic["projectName"] = project.objects.get(id=p.projectId).name
            dic["elementNum"] = len(element.objects.filter(pageId=p.id))
            page_list.append(dic)
        result = dict()
        result["total"] = total
        result["pages"] = page_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, page_id):
        p = get_model(page, id=page_id)
        if not p:
            return JsonResponse.BadRequest("该页面不存在")
        result = model_to_dict(p, ["id", "projectId", 'name', 'remark'])
        result["projectName"] = project.objects.get(id=p.projectId).name
        result["createTime"] = p.createTime.strftime('%Y-%m-%d %H:%M:%S')
        result["elementNum"] = len(element.objects.filter(pageId=p.id))
        return JsonResponse.OK(message="ok", data=result)


class Element:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse(500, "json格式错误")
        e = element()
        e.name = parameter.get("name", "")
        e.remark = parameter.get("remark", "")
        e.pageId = str(parameter.get("pageId", 0))
        e.pageId = int(e.pageId) if e.pageId.isdigit() else 0
        e.by = parameter.get("by", "")
        e.locator = parameter.get("locator", "")
        p = get_model(page, id=e.pageId)
        if not p:
            return JsonResponse(404, "该页面不存在")
        e.projectId = p.projectId
        try:
            e.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        e.name = e.name.strip()
        e.by = e.by.lower()
        if get_model(element, False, name__exact=e.name, pageId=e.pageId):
            return JsonResponse.BadRequest("页面已存在该元素,请修改后重试")
        try:
            e.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, element_id):
        e = get_model(element, id=element_id)
        if not e:
            JsonResponse(404, "该元素不存在")
        try:
            e.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, element_id):
        # 获取元素
        e = get_model(element, id=element_id)
        if not e:
            return JsonResponse(404, "该页面元素不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse(500, "json格式错误")
        # 判断参数有效性
        e.name = str(parameter.get("name", e.name))
        e.remark = str(parameter.get("remark", e.remark))
        e.by = parameter.get("by", e.by)
        e.locator = parameter.get("locator", e.locator)
        try:
            e.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        e.name = e.name.strip()
        e.by = e.by.lower()
        # 判断重复
        if element.objects.filter(name__exact=e.name, pageId=e.pageId).exclude(id=e.id):
            return JsonResponse.BadRequest("页面已存在该元素,请修改后重试")
        # 保存
        try:
            e.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() and int(projectId) >= 1 else 0
        pageId = parameter.get("pageId", 0)
        pageId = int(pageId) if str(pageId).isdigit() and int(pageId) >= 1 else 0
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        name = parameter.get("name") if parameter.get("name", "") else ""
        try:
            elements = element.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                              name__contains=name).order_by("-createTime")
            if projectId:
                elements = elements.filter(projectId=projectId)
            if pageId:
                elements = elements.filter(pageId=pageId)
            total = len(elements)
        except:
            return JsonResponse(400, "时间参数错误")
        elements = elements[(page_index - 1) * page_size:page_index * page_size]
        element_list = list()
        for e in elements:
            dic = model_to_dict(e, ["id", "projectId", "pageId", 'name', 'by', 'locator', 'remark'])
            dic["createTime"] = e.createTime.strftime('%Y-%m-%d %H:%M:%S')
            dic["pageName"] = page.objects.get(id=e.pageId).name
            dic["projectName"] = project.objects.get(id=e.projectId).name
            element_list.append(dic)
        result = dict()
        result["total"] = total
        result["elements"] = element_list
        return JsonResponse(200, "ok", result)

    @staticmethod
    def get(request, element_id):
        e = get_model(element, id=element_id)
        if not e:
            return JsonResponse.BadRequest("该页面元素不存在")
        result = model_to_dict(e, ["id", 'name', "projectId", 'pageId', 'by', 'locator', 'remark'])
        result["pageName"] = page.objects.get(id=e.pageId).name
        result["projectName"] = project.objects.get(id=e.projectId).name
        result["createTime"] = e.createTime.strftime('%Y-%m-%d %H:%M:%S')
        return JsonResponse(200, "ok", result)


class Keyword:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        kw = keyword()
        kw.name = parameter.get("name", None)
        kw.remark = parameter.get("remark", None)
        kw.package = parameter.get("package", None)
        kw.clazz = parameter.get("clazz", None)
        kw.method = parameter.get("method", None)
        kw.type = parameter.get("type", 0)
        kw.params = parameter.get("params", None)
        kw.steps = parameter.get("steps", None)
        kw.projectId = parameter.get("projectId", 0)
        kw.projectId = int(kw.projectId) if str(kw.projectId).isdigit() else 0
        try:
            kw.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        kw.name = kw.name.strip()
        projectIds = [0, kw.projectId]
        ks = get_model(keyword, False, name__exact=kw.name, projectId__in=projectIds)
        if ks:
            return JsonResponse.BadRequest("已存在该关键字,请修改后重试")
        if str(kw.type) == "2":
            from Product.models import Params
            params = list()
            steps_ = kw.steps
            for step in steps_:
                if isinstance(step, dict):
                    values = step.get("values")
                    if isinstance(values, list):
                        for value in values:
                            p = Params(value)
                            if p.isParameter:
                                pd = dict()
                                pd["type"] = p.Type
                                pd['key'] = p.value
                                params.append(pd)
                    else:
                        return JsonResponse.BadRequest("step对象中的values不是列表")
                else:
                    return JsonResponse.BadRequest("step不是json对象格式")
            kw.params = json.dumps(params, ensure_ascii=False)
            kw.steps = json.dumps(kw.steps, ensure_ascii=False)
        elif kw.params:
            kw.params = json.dumps(kw.params, ensure_ascii=False)
        try:
            kw.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, keyword_id):
        kw = get_model(keyword, id=keyword_id)
        if not kw:
            return JsonResponse(404, "该关键字不存在")
        try:
            kw.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, keyword_id):
        kw = get_model(keyword, id=keyword_id)
        if not kw:
            return JsonResponse.BadRequest("该关键字不存在")
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        kw.name = parameter.get("name", '')
        kw.remark = parameter.get("remark", '')
        kw.package = parameter.get("package", '')
        kw.clazz = parameter.get("clazz", '')
        kw.method = parameter.get("method", '')
        kw.params = parameter.get("params", kw.params)
        kw.steps = json.dumps(parameter.get("steps", []), ensure_ascii=False)
        try:
            kw.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        kw.name = kw.name.strip()
        projectIds = [0, kw.projectId]
        if keyword.objects.filter(name__exact=kw.name, projectId__in=projectIds).exclude(id=kw.id):
            return JsonResponse.BadRequest("已存在该关键字,请修改后重试")
        # 保存
        if kw.type == 2:
            from Product.models import Params
            params = list()
            for step in json.loads(kw.steps):
                for value in step.get("values"):
                    p = Params(value)
                    if p.isParameter:
                        pd = dict()
                        pd["type"] = p.Type
                        pd['key'] = p.value
                        params.append(pd)
            kw.params = json.dumps(params, ensure_ascii=False)
        elif kw.params:
            kw.params = json.dumps(kw.params, ensure_ascii=False)
        try:
            kw.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() else 0
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        name = parameter.get("name") if parameter.get("name", "") else ""
        t = parameter.get("type") if parameter.get("type", "") else None
        try:
            ks = keyword.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                        name__contains=name).order_by("-createTime")
            if projectId:
                ks = ks.filter(projectId__in=[0, projectId])
            if t:
                ks = ks.filter(type=t)
            total = len(ks)
        except:
            return JsonResponse(400, "时间参数错误")
        ks = ks[(page_index - 1) * page_size:page_index * page_size]
        kw_list = list()
        for k in ks:
            dic = model_to_dict(k, ["id", "projectId", 'name', 'type', 'package', 'clazz', 'method',
                                    'remark'])
            dic["projectName"] = "通用" if k.projectId == 0 else project.objects.get(id=k.projectId).name
            dic["params"] = json.loads(k.params) if k.params else None
            dic["steps"] = json.loads(k.steps) if k.steps else None
            dic["createTime"] = k.createTime.strftime('%Y-%m-%d %H:%M:%S')
            kw_list.append(dic)
        result = dict()
        result["total"] = total
        result["keywords"] = kw_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, keyword_id):
        kw = get_model(keyword, id=keyword_id)
        if not kw:
            return JsonResponse.BadRequest("该关键字不存在")
        result = model_to_dict(kw, ["id", "projectId", 'name', 'type', 'package', 'clazz', 'method', '', 'steps',
                                    'remark'])
        result["projectName"] = "通用" if kw.projectId == 0 else project.objects.get(id=kw.projectId).name
        result["params"] = json.loads(kw.params) if kw.params else None
        result["createTime"] = kw.createTime.strftime('%Y-%m-%d %H:%M:%S')
        steps = json.loads(kw.steps) if kw.steps else []
        steps_ = list()
        for step in steps:
            info = dict()
            info["data"] = step
            kw = get_model(keyword, id=step["keywordId"])
            info["keywordName"] = kw.name if kw else ""
            values = step["values"]
            info_value = list()
            for value in values:
                pa = dict()
                pa["isParameter"] = value.get("isParameter", False)
                pa["type"] = value["type"]
                pa["value"] = value["value"]
                pa["key"] = value["key"]
                if not value.get("isParameter", False):
                    if value["type"] == "element":
                        ele = get_model(element, id=value["value"])
                        pa["pageId"] = ele.pageId
                        pa["elementName"] = ele.name
                info_value.append(pa)
            info["viewData"] = info_value
            steps_.append(info)
        result["steps"] = steps_
        return JsonResponse.OK(message="ok", data=result)


class TestCase:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        tc = testcase()
        tc.projectId = parameter.get("projectId", 0)
        tc.level = parameter.get("level", 1)
        tc.level = int(tc.level) if str(tc.level).isdigit() else 0
        tc.title = parameter.get("title", None)
        tc.beforeLogin = list();
        bl = parameter.get("beforeLogin", []);
        if isinstance(bl, str):
            tc.beforeLogin.append(bl);
        elif bl:
            tc.beforeLogin.extend(bl);
        tc.remark = parameter.get("remark", None)
        tc.steps = parameter.get("steps", [])
        tc.parameter = parameter.get("parameter", [])
        tc.checkType = parameter.get("checkType", None)
        tc.checkValue = parameter.get("checkValue", None)
        try:
            tc.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        tc.title = tc.title.strip()
        tc.beforeLogin = json.dumps(tc.beforeLogin, ensure_ascii=False)
        tc.parameter = json.dumps(tc.parameter, ensure_ascii=False)
        tc.steps = json.dumps(tc.steps, ensure_ascii=False)
        ks = get_model(testcase, False, title__exact=tc.title, projectId=tc.projectId)
        if ks:
            return JsonResponse.BadRequest("项目已存在该用例,请修改后重试")
        try:
            tc.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, testcase_id):
        tc = get_model(testcase, id=testcase_id)
        if not tc:
            return JsonResponse(404, "该用例不存在")
        try:
            tc.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, testcase_id):
        # 获取元素
        tc = get_model(testcase, id=testcase_id)
        if not tc:
            return JsonResponse.BadRequest("该用例不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # 判断参数有效性
        tc.level = parameter.get("level", 1)
        tc.level = int(tc.level) if str(tc.level).isdigit() else 0
        tc.title = parameter.get("title", None)
        tc.remark = parameter.get("remark", None)
        tc.steps = parameter.get("steps", [])
        tc.parameter = parameter.get("parameter", [])
        bl = parameter.get("beforeLogin", []);
        tc.beforeLogin = []
        if isinstance(bl, str):
            tc.beforeLogin.append(bl);
        elif bl:
            tc.beforeLogin.extend(bl);
        tc.checkType = parameter.get("checkType", "")
        tc.checkValue = parameter.get("checkValue", "")
        try:
            tc.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        tc.title = tc.title.strip()
        tc.beforeLogin = json.dumps(tc.beforeLogin, ensure_ascii=False)
        tc.parameter = json.dumps(tc.parameter, ensure_ascii=False)
        tc.steps = json.dumps(tc.steps, ensure_ascii=False)
        if testcase.objects.filter(title__exact=tc.title, projectId=tc.projectId).exclude(id=tc.id):
            return JsonResponse.BadRequest("项目已存在该测试用例,请修改后重试")
        # 保存
        try:
            tc.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() and int(projectId) >= 1 else 0
        title = parameter.get("title") if parameter.get("title", "") else ""
        title = title.strip()
        level = parameter.get("level") if parameter.get("level", 0) else 0
        level = int(level) if str(level).isdigit() and int(level) >= 1 else 0
        # status = parameter.get("status") if parameter.get("status", 0) else 0
        # status = int(status) if str(status).isdigit() and int(status) >= 1 else 0
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        try:
            tcs = testcase.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                          title__contains=title).order_by("-createTime")
            if projectId:
                tcs = tcs.filter(projectId=projectId)
            if level:
                tcs = tcs.filter(level=level)
            # if status:
            #     tcs = tcs.filter(status=status)
            total = len(tcs)
        except:
            return JsonResponse(400, "时间参数错误")
        tcs = tcs[(page_index - 1) * page_size:page_index * page_size]
        tcs_list = list()
        for tc in tcs:
            dic = model_to_dict(tc, ["id", "projectId", 'title', 'level', 'remark', 'checkType', 'checkValue'])
            pro = get_model(project, id=tc.projectId)
            dic["projectName"] = pro.name if pro else ""
            dic["parameter"] = json.loads(tc.parameter) if tc.parameter else []
            dic["steps"] = json.loads(tc.steps) if tc.steps else []
            dic["beforeLogin"] = json.loads(tc.beforeLogin) if tc.beforeLogin else []
            dic["createTime"] = tc.createTime.strftime('%Y-%m-%d %H:%M:%S')
            tcs_list.append(dic)
        result = dict()
        result["total"] = total
        result["testcase"] = tcs_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, testcase_id):
        tc = get_model(testcase, id=testcase_id)
        if not tc:
            return JsonResponse.BadRequest("该测试用例不存在")
        result = model_to_dict(tc, ["id", "projectId", 'title', 'level', 'remark', 'checkType', 'checkValue'])
        result['projectName'] = get_model(project, id=tc.projectId).name
        result["parameter"] = json.loads(tc.parameter) if tc.parameter else []
        if tc.checkType == "element":
            page_element = get_model(element, id=tc.checkValue)
            pageId = page_element.pageId if page_element else 0
            result["pageId"] = pageId;
        steps = json.loads(tc.steps) if tc.steps else []
        steps_ = list()
        for step in steps:
            info = dict()
            info["data"] = step
            kw = get_model(keyword, id=step["keywordId"])
            info["keywordName"] = kw.name if kw else ""
            values = step["values"]
            info_value = list()
            for value in values:
                pa = dict()
                pa["isParameter"] = value.get("isParameter", False)
                pa["type"] = value["type"]
                pa["value"] = value["value"]
                pa["key"] = value["key"]
                if not pa["isParameter"]:
                    if value["type"] == "element":
                        ele = get_model(element, id=value["value"])
                        pa["pageId"] = ele.pageId
                        pa["elementName"] = ele.name
                info_value.append(pa)
            info["viewData"] = info_value
            steps_.append(info)
        result["steps"] = steps_
        result["beforeLogin"] = json.loads(tc.beforeLogin) if tc.beforeLogin else []
        result["createTime"] = tc.createTime.strftime('%Y-%m-%d %H:%M:%S')
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    @post
    def test(request, testcase_id):
        tc = get_model(testcase, id=testcase_id)
        if not tc:
            return JsonResponse.BadRequest("该测试用例不存在")
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        browsers = parameter.get("browsers", [1])
        environments = parameter.get('environments', [])
        if not (browsers and isinstance(browsers, list)):
            return JsonResponse.BadRequest("参数错误：browsers应该是个列表")
        for browser in browsers:
            if not (str(browser).isdigit() and int(browser) > 0):
                return JsonResponse.BadRequest("参数错误：browser应该是个正确的Id")
        r = Result.objects.create(projectId=tc.projectId, testcaseId=tc.id, checkValue=tc.checkValue,
                                  checkType=tc.checkType, title=tc.title, beforeLogin=tc.beforeLogin,
                                  steps=tc.steps, parameter=tc.parameter,
                                  browsers=json.dumps(browsers, ensure_ascii=False),
                                  environments=json.dumps(environments, ensure_ascii=False))
        SplitTask.delay(r.id)
        return JsonResponse(200, 'ok', r.id)


class TestResult:
    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        taskId = parameter.get("taskId", 0)
        taskId = int(taskId) if str(taskId).isdigit() and int(taskId) >= 1 else 0
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() and int(projectId) >= 1 else 0
        testcaseId = parameter.get("testcaseId", 0)
        testcaseId = int(testcaseId) if str(testcaseId).isdigit() and int(testcaseId) >= 1 else 0
        title = parameter.get("title") if parameter.get("title", "") else ""
        title = title.strip()
        status = parameter.get("status") if parameter.get("status", 0) else 0
        status = int(status) if str(status).isdigit() and int(status) >= 1 else 0
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        try:
            res = Result.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                        title__contains=title).order_by("-createTime")
            if taskId:
                res = res.filter(taskId=taskId)
            elif projectId:
                res = res.filter(projectId=projectId)
            if testcaseId:
                res = res.filter(testcaseId=testcaseId)
            if status:
                res = res.filter(status=status)
            total = len(res)
        except:
            return JsonResponse(400, "时间参数错误")
        res = res[(page_index - 1) * page_size:page_index * page_size]
        tcs_list = list()
        for re in res:
            dic = model_to_dict(re, ["id", "projectId", "taskId", "testcaseId", 'title', 'status', 'checkType',
                                     'checkValue'])
            dic["parameter"] = json.loads(str(re.parameter)) if re.parameter else []
            task = get_model(Task, id=re.taskId)
            dic["taskName"] = task.name if task else ""
            tc = get_model(project, id=re.projectId)
            dic["projectName"] = tc.name if tc else ""
            dic["steps"] = json.loads(str(re.steps)) if re.steps else []
            dic["beforeLogin"] = json.loads(re.beforeLogin) if re.beforeLogin else []
            dic["browsers"] = json.loads(re.browsers) if re.browsers else []
            dic["environments"] = json.loads(re.environments) if re.environments else []
            dic["createTime"] = re.createTime.strftime('%Y-%m-%d %H:%M:%S')
            tcs_list.append(dic)
        result = dict()
        result["total"] = total
        result["results"] = tcs_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, result_id):
        re = get_model(Result, id=result_id)
        if not re:
            return JsonResponse.BadRequest("该测试结果不存在")
        result = model_to_dict(re, ["id", "projectId", "taskId", "testcaseId", 'title', 'status', 'checkType',
                                    'checkValue'])
        result["parameter"] = json.loads(re.parameter) if re.parameter else []
        result["steps"] = json.loads(re.steps) if re.steps else []
        beforeLogin = json.loads(re.beforeLogin) if re.beforeLogin else [];
        result["beforeLogin"] = list()
        if beforeLogin:
            for bl in beforeLogin:
                bl = get_model(LoginConfig, id=bl)
                bl = bl.name if bl else ""
                result["beforeLogin"].append(bl)
        browsers = json.loads(re.browsers) if re.browsers else []
        result["browsers"] = list()
        for browser in browsers:
            browser = get_model(Browser, id=browser)
            browser = browser.name if browser else ""
            result["browsers"].append(browser)
        environments = json.loads(re.environments) if re.environments else []
        result["environments"] = list()
        if environments:
            for e in environments:
                e = get_model(environment, id=e)
                e = e.name if e else ""
                result["environments"].append(e)
        result["createTime"] = re.createTime.strftime('%Y-%m-%d %H:%M:%S')
        tc = get_model(project, id=re.projectId)
        result["projectName"] = tc.name if tc else ""
        from .models import SplitResult
        split = get_model(SplitResult, False, resultId=re.id)
        splitResult = list()
        for s in split:
            sd = model_to_dict(s, ["status", 'expect', 'remark'])
            sd['browser'] = get_model(Browser, id=s.browserId).name if get_model(Browser, id=s.browserId) else ""
            sd['environment'] = get_model(environment, id=s.environmentId).name if get_model(environment,
                                                                                             id=s.environmentId) else ""
            sd["startTime"] = s.startTime.strftime('%Y-%m-%d %H:%M:%S') if s.startTime else None
            sd["finishTime"] = s.finishTime.strftime('%Y-%m-%d %H:%M:%S') if s.finishTime else None
            sd["parameter"] = json.loads(s.parameter) if s.parameter else {}
            splitResult.append(sd)
        result['splitResults'] = splitResult
        return JsonResponse.OK(message="ok", data=result)


class Public:
    @staticmethod
    def data(request):
        from .models import Browser
        browsers = Browser.objects.all()
        browser_re = list()
        for browser in browsers:
            dic = model_to_dict(browser, ['id', "name", "value", "remark"])
            browser_re.append(dic)
        result = dict()
        result['browsers'] = browser_re
        return JsonResponse(200, "ok", result)

    @staticmethod
    def index(request):
        import datetime
        data = list()
        projects = project.objects.all()
        today = datetime.datetime.now().strftime('%Y-%m-%d')
        for p in projects:
            info = dict()
            info["projectName"] = p.name
            info["testcaseNum"] = len(testcase.objects.filter(projectId=p.id))
            st = Result.objects.filter(projectId=p.id, status=30)
            info["successfulTotal"] = len(st)
            ft = Result.objects.filter(projectId=p.id).exclude(status=30)
            info["failureTotal"] = len(ft)
            info["successfulToday"] = len(
                st.filter(createTime__lt=(today + " 23:59:59"), createTime__gt=(today + " 00:00:00")))
            info["failureToday"] = len(
                ft.filter(createTime__lt=(today + " 23:59:59"), createTime__gt=(today + " 00:00:00")))
            data.append(info)
        return JsonResponse(200, "ok", data)

    @staticmethod
    def bar_char(request):
        all_project = project.objects.all()
        project_list = list()
        data_queue = list()
        data_testing = list()
        data_succeed = list()
        data_failure = list()
        for p in all_project:
            project_list.append(p.name)
            all_result = Result.objects.filter(projectId=p.id)
            data_queue.append(len(all_result.filter(status=10)))
            data_testing.append(len(all_result.filter(status=20)))
            data_succeed.append(len(all_result.filter(status=30)))
            data_failure.append(len(all_result.filter(status=40)))
        result = dict()
        result["project"] = project_list
        data = list();
        data.append({"name": "队列中", "data": data_queue})
        data.append({"name": "测试中", "data": data_testing})
        data.append({"name": "成功", "data": data_succeed})
        data.append({"name": "失败", "data": data_failure})
        result["data"] = data
        return JsonResponse(200, "ok", result)

    @staticmethod
    def line_char(request):
        from datetime import datetime, timedelta
        def getWeek(n=0):
            now = datetime.now()
            if n < 0:
                return datetime(now.year, now.month, now.day)
            else:
                oldData = now - timedelta(days=n * 1)
                return datetime(oldData.year, oldData.month, oldData.day)

        days = [getWeek(x) for x in [6, 5, 4, 3, 2, 1, 0]];
        data_succeed = list()
        data_failure = list()
        data_list = list()
        for d in days:
            maxDay = datetime(d.year, d.month, d.day, 23, 59, 59);
            data_list.append(d.strftime('%Y-%m-%d'))
            all_result = Result.objects.all()
            data_succeed.append(len(all_result.filter(status=30, createTime__lt=maxDay, createTime__gt=d)))
            data_failure.append(len(all_result.filter(status=40, createTime__lt=maxDay, createTime__gt=d)))
        result = dict()
        result["days"] = data_list
        data = list();
        data.append({"name": "成功", "data": data_succeed})
        data.append({"name": "失败", "data": data_failure})
        result["data"] = data
        return JsonResponse(200, "ok", result)


class TestTasks:
    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        t = Task()
        t.name = parameter.get("name", "")
        t.remark = parameter.get("remark", "")
        t.testcases = parameter.get("testcases", [])
        t.browsers = parameter.get("browsers", [1])
        t.timing = parameter.get("timing", True)
        try:
            t.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        t.name = t.name.strip()
        t.testcases = json.dumps(t.testcases, ensure_ascii=False)
        t.browsers = json.dumps(t.browsers, ensure_ascii=False)
        if Task.objects.filter(name__exact=t.name):
            return JsonResponse.BadRequest("该任务已存在，请修改后重试")
        try:
            t.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, task_id):
        t = get_model(Task, id=task_id)
        if not t:
            return JsonResponse(500, "该任务不存在")
        try:
            t.delete()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, task_id):
        # 获取项目
        t = get_model(Task, id=task_id)
        if not t:
            return JsonResponse.BadRequest("该任务不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # 判断参数有效性
        t.name = parameter.get("name", "")
        t.remark = parameter.get("remark", "")
        t.testcases = parameter.get("testcases", [])
        t.browsers = parameter.get("browsers", [1])
        t.timing = parameter.get("timing", True)
        try:
            t.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        # 判断重复
        t.name = t.name.strip()
        t.testcases = json.dumps(t.testcases, ensure_ascii=False)
        t.browsers = json.dumps(t.browsers, ensure_ascii=False)
        if Task.objects.filter(name__exact=t.name).exclude(id=t.id):
            return JsonResponse.BadRequest("任务已存在,请修改后重试")
        # 保存
        try:
            t.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        name = parameter.get("name") if parameter.get("name", "") else ""
        timing = parameter.get("timing", 0)
        timing = int(timing) if str(timing).isdigit() and int(timing) >= 1 else 0

        try:
            ts = Task.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                     name__contains=name).order_by("-createTime")
            if timing and timing in [1, 2]:
                ts = ts.filter(timing=timing)
            total = len(ts)
        except:
            return JsonResponse(400, "时间参数错误")
        ts = ts[(page_index - 1) * page_size:page_index * page_size]
        _list = list()
        for t in ts:
            dic = model_to_dict(t, ["id", 'name', 'remark', 'timing'])
            dic["browsers"] = json.loads(t.browsers) if t.browsers else None
            dic["testcases"] = json.loads(t.testcases) if t.testcases else None
            dic["createTime"] = t.createTime.strftime('%Y-%m-%d %H:%M:%S')
            _list.append(dic)
        result = dict()
        result["total"] = total
        result["tasks"] = _list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, task_id):
        t = get_model(Task, id=task_id)
        if not t:
            return JsonResponse.BadRequest("该任务不存在")
        result = model_to_dict(t, ["id", 'name', 'remark', 'timing'])
        result["browsers"] = json.loads(t.browsers) if t.browsers else None
        tcs = json.loads(t.testcases) if t.testcases else None
        testcaseInfo = list();
        for tci in tcs:
            oneTestCase = dict()
            TC = get_model(testcase, id=tci.get("id"));
            oneTestCase["testcaseTitle"] = TC.title if TC else "";
            pro = get_model(project, id=TC.projectId)
            oneTestCase["projectName"] = pro.name if pro else "";
            ES = list()
            for e in tci.get("environments"):
                E = get_model(environment, id=e)
                ES.append(E.name)
            oneTestCase["environments"] = ES;
            oneTestCase["data"] = tci;
            testcaseInfo.append(oneTestCase)
        result["testcases"] = testcaseInfo
        result["createTime"] = t.createTime.strftime('%Y-%m-%d %H:%M:%S')
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    @post
    def test(request, task_id):
        t = get_model(Task, id=task_id)
        if not t:
            return JsonResponse(404, "该任务不存在")
        browsers = json.loads(t.browsers) if t.browsers else []
        testcases = json.loads(t.testcases) if t.testcases else []
        for tc in testcases:
            environments = tc.get("environments", [])
            tc = get_model(testcase, id=tc.get("id", 0))
            r = Result.objects.create(projectId=tc.projectId, testcaseId=tc.id, checkValue=tc.checkValue,
                                      checkType=tc.checkType, title=tc.title, beforeLogin=tc.beforeLogin,
                                      steps=tc.steps, parameter=tc.parameter,
                                      browsers=json.dumps(browsers, ensure_ascii=False),
                                      environments=json.dumps(environments, ensure_ascii=False), taskId=t.id)
            SplitTask.delay(r.id)
        return JsonResponse.OK()


class Login:

    @staticmethod
    @post
    def create(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        l = LoginConfig()
        l.projectId = parameter.get("projectId", 0)
        l.projectId = int(l.projectId) if str(l.projectId).isdigit() else 0
        l.name = parameter.get("name", None)
        l.remark = parameter.get("remark", None)
        l.steps = parameter.get("steps", [])
        l.checkType = parameter.get("checkType", "")
        l.checkValue = parameter.get("checkValue", "")
        try:
            l.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        from Product.models import Params
        params = list()
        for step in l.steps:
            if isinstance(step, dict):
                values = step.get("values")
                if isinstance(values, list):
                    for value in values:
                        p = Params(value)
                        if p.isParameter:
                            pd = dict()
                            pd["type"] = p.Type
                            pd['key'] = p.value
                            params.append(pd)
                else:
                    return JsonResponse.BadRequest("step对象中的values不是列表")
            else:
                return JsonResponse.BadRequest("step不是json对象格式")
        l.params = json.dumps(params, ensure_ascii=False)
        l.steps = json.dumps(l.steps, ensure_ascii=False)
        l.name = l.name.strip()
        lcs = get_model(LoginConfig, False, name__exact=l.name, projectId__in=[0, l.projectId])
        if lcs:
            return JsonResponse.BadRequest("该登陆配置已存在,请修改后重试")
        try:
            l.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def delete(request, login_id):
        l = get_model(LoginConfig, id=login_id)
        if not l:
            return JsonResponse(404, "该登陆配置不存在")
        try:
            EnvironmentLogin.objects.filter(loginId=l.id).delete()
            l.delete()
        except:
            return JsonResponse(500, "服务器发生错误")
        return JsonResponse.OK()

    @staticmethod
    @post
    def edit(request, login_id):
        # 获取元素
        l = get_model(LoginConfig, id=login_id)
        if not l:
            return JsonResponse.BadRequest("该用例不存在")
        # 获取请求参数
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        # 判断参数有效性
        l.name = parameter.get("name", l.name)
        l.remark = parameter.get("remark", l.remark)
        l.steps = parameter.get("steps", l.steps)
        l.checkType = parameter.get("checkType", l.checkType)
        l.checkValue = parameter.get("checkValue", l.checkValue)
        try:
            l.clean()
        except ValidationError as ve:
            return JsonResponse.BadRequest(','.join(ve.messages))
        steps = []
        if l.steps:
            if isinstance(l.steps, list):
                steps = l.steps
            else:
                steps = json.loads(l.steps)
        from Product.models import Params
        params = list()
        for step in steps:
            values = step.get("values")
            for value in values:
                p = Params(value)
                if p.isParameter:
                    pd = dict()
                    pd["type"] = p.Type
                    pd['key'] = p.value
                    params.append(pd)
        l.params = json.dumps(params, ensure_ascii=False)
        l.steps = json.dumps(l.steps, ensure_ascii=False)
        l.name = l.name.strip()
        if LoginConfig.objects.filter(name__exact=l.name, projectId__in=[0, l.projectId]).exclude(id=l.id):
            return JsonResponse.BadRequest("项目已存在该登陆配置,请修改后重试")
        # 保存
        try:
            l.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse.OK()

    @staticmethod
    def find(request):
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        projectId = parameter.get("projectId", 0)
        projectId = int(projectId) if str(projectId).isdigit() and int(projectId) >= 1 else 0
        name = parameter.get("name") if parameter.get("name", "") else ""
        name = name.strip()
        page_index = request.GET.get("p", 1)
        page_index = int(page_index) if str(page_index).isdigit() and int(page_index) >= 1 else 1
        page_size = parameter.get("pageSize", 10)
        page_size = int(page_size) if str(page_size).isdigit() and int(page_size) >= 1 else 10
        start_time = "2018-01-01 00:00:00"
        start_time = parameter.get("startTime", start_time) if parameter.get("startTime", start_time) else start_time
        now = timezone.now().strftime('%Y-%m-%d %H:%M:%S')
        end_time = parameter.get("endTime", now) if parameter.get("endTime", now) else now
        try:
            ls = LoginConfig.objects.filter(createTime__lt=end_time, createTime__gt=start_time,
                                            name__contains=name).order_by("-createTime")
            if projectId != 0:
                ls = ls.filter(projectId__in=[0, projectId])
            total = len(ls)
        except:
            return JsonResponse(400, "时间参数错误")
        ls = ls[(page_index - 1) * page_size:page_index * page_size]
        ls_list = list()
        for l in ls:
            dic = model_to_dict(l, ["id", "projectId", 'name', 'remark', 'checkType', 'checkValue'])
            dic["params"] = json.loads(l.params) if l.params else None
            dic["steps"] = json.loads(l.steps) if l.steps else None
            dic["projectName"] = "" if l.projectId == 0 else get_model(project, id=l.projectId).name
            dic["bindNum"] = len(EnvironmentLogin.objects.filter(loginId=l.id))
            dic["createTime"] = l.createTime.strftime('%Y-%m-%d %H:%M:%S')
            ls_list.append(dic)
        result = dict()
        result["total"] = total
        result["logins"] = ls_list
        return JsonResponse.OK(message="ok", data=result)

    @staticmethod
    def get(request, login_id):
        l = get_model(LoginConfig, id=login_id)
        if not l:
            return JsonResponse.BadRequest("该测试用例不存在")
        dic = model_to_dict(l, ["id", "projectId", 'name', 'remark', 'checkType', 'checkValue'])
        dic["projectName"] = "" if l.projectId == 0 else get_model(project, id=l.projectId).name
        dic["params"] = json.loads(l.params) if l.params else None
        steps = json.loads(l.steps) if l.steps else []
        steps_ = list()
        if l.checkType == "element":
            page_element = get_model(element, id=l.checkValue)
            pageId = page_element.pageId if page_element else 0
            dic["pageId"] = pageId;
        for step in steps:
            info = dict()
            info["data"] = step
            kw = get_model(keyword, id=step["keywordId"])
            info["keywordName"] = kw.name if kw else ""
            values = step["values"]
            info_value = list()
            for value in values:
                pa = dict()
                pa["isParameter"] = value.get("isParameter", False)
                pa["type"] = value["type"]
                pa["value"] = value["value"]
                pa["key"] = value["key"]
                if not pa["isParameter"]:
                    if value["type"] == "element":
                        ele = get_model(element, id=value["value"])
                        pa["pageId"] = ele.pageId
                        pa["elementName"] = ele.name
                info_value.append(pa)
            info["viewData"] = info_value
            steps_.append(info)
        dic["steps"] = steps_
        dic["createTime"] = l.createTime.strftime('%Y-%m-%d %H:%M:%S')
        els = EnvironmentLogin.objects.filter(loginId=l.id)
        e_list = []
        for el in els:
            ep = model_to_dict(el, ["id", 'environmentId'])
            environment_ = get_model(environment, id=el.environmentId)
            environmentName = environment_.name if environment_ else ""
            ep['environmentName'] = environmentName
            ep['parameter'] = json.loads(el.parameter) if el.parameter else []
            e_list.append(ep)
        dic["bind"] = e_list
        return JsonResponse.OK(message="ok", data=dic)

    @staticmethod
    @post
    def bind(request, login_id):
        lc = get_model(LoginConfig, id=login_id)
        if not lc:
            return JsonResponse.BadRequest("该登陆配置不存在")
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        environmentId = parameter.get('environmentId', 0)
        if not (str(environmentId).isdigit() and int(environmentId) > 0):
            return JsonResponse.BadRequest("请选择正确的环境")
        parameter = parameter.get('parameter', {})
        if EnvironmentLogin.objects.filter(environmentId=environmentId, loginId=lc.id):
            return JsonResponse(400, '该登陆配置与该环境已绑定')
        el = EnvironmentLogin()
        el.loginId = lc.id
        el.environmentId = environmentId
        if not isinstance(parameter, dict):
            return JsonResponse(400, '参数值错误:parameter')
        el.parameter = json.dumps(parameter, ensure_ascii=False)
        try:
            el.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse(200, 'ok')

    @staticmethod
    @post
    def unbind(request, EnvironmentLogin_id):
        el = get_model(EnvironmentLogin, id=EnvironmentLogin_id)
        if not el:
            return JsonResponse.BadRequest("该绑定关系不存在")
        try:
            el.delete()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse(200, 'ok')

    @staticmethod
    @post
    def edit_bind(request, EnvironmentLogin_id):
        el = get_model(EnvironmentLogin, id=EnvironmentLogin_id)
        if not el:
            return JsonResponse.BadRequest("该绑定关系不存在")
        try:
            parameter = get_request_body(request)
        except ValueError:
            return JsonResponse.BadRequest("json格式错误")
        parameter = parameter.get('parameter', {})
        if not isinstance(parameter, dict):
            return JsonResponse(400, '参数值错误：parameter')
        el.parameter = json.dumps(parameter, ensure_ascii=False)
        try:
            el.save()
        except:
            return JsonResponse.ServerError("服务器发送错误")
        return JsonResponse(200, 'ok')
