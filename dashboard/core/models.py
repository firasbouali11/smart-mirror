from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token

# Create your models here.


class Mirror(models.Model):
    owner_name = models.CharField(max_length=20)

    def __str__(self):
        return self.owner_name

class ProfileManager(BaseUserManager):
    def create_user(self, username, email, image,mirror,password=None):
        if not email or not username:
            raise ValueError("missing values !")

        user = self.model(
            username=username,
            email=self.normalize_email(email),
            image=image,
            mirror=mirror
        )
        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, username, password, email,image=None,mirror=None):
        superuser = self.create_user(username, email,image, password)
        superuser.is_staff = True
        superuser.is_admin = True
        superuser.is_superuser = True

        superuser.save(using=self._db)
        return superuser


class Profile(AbstractBaseUser):
    username = models.CharField(max_length=20,unique=True)
    email = models.EmailField(max_length=20, unique=True)
    image = models.ImageField(upload_to="media",null=True)
    mirror = models.ForeignKey(Mirror,on_delete=models.CASCADE,null=True)
    date_joined = models.DateTimeField(auto_now=True)
    last_login = models.DateTimeField(auto_now_add=True)
    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = ["email"]

    objects = ProfileManager()

    def has_perm(self, perm, obj=None):
        return self.is_admin

    def has_module_perms(self, app_label):
        return True


class Task(models.Model):
    task = models.CharField(max_length=255)
    date = models.DateTimeField()
    created = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(Profile, on_delete=models.CASCADE)

    def __str__(self):
        return self.user.username



@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)