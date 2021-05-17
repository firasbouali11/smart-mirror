from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Profile,Task,Mirror,Email


# Register your models here

class AccountAdmin(UserAdmin):
    list_display = ["email","username", "date_joined", "last_login"]
    readonly_fields = ["last_login", "date_joined"]
    search_fields = ["username","email"]
    fieldsets = ()
    filter_horizontal = ()
    list_filter = ()


admin.site.register(Profile, AccountAdmin)
admin.site.register(Task)
admin.site.register(Email)
admin.site.register(Mirror)
