def get_model(model, get=True, *args, **kwargs, ):
    from django.db.models.base import ModelBase
    if isinstance(model, ModelBase):
        if get:
            try:
                return model.objects.get(*args, **kwargs)
            except:
                return None
        else:
            return model.objects.filter(*args, **kwargs)
    else:
        raise TypeError("model 没有继承 django.db.models.base.ModelBase")


def isLegal(string, length=5, match_='([^a-z0-9A-Z_])+'):
    import re
    pattern = re.compile(match_)
    match = pattern.findall(string)
    if string and len(string) > length:
        if match:
            return False
        else:
            return True
    else:
        return False

def md5(string):
    import hashlib
    return hashlib.md5(string.encode()).hexdigest()

def validateEmail(email):
    import re
    if len(email) > 7:
        if re.match("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$", email):
            return True
    return False