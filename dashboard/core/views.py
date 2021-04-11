from rest_framework import viewsets
from .models import Profile, Task, Mirror
from .serializers import ProfileSerializer, TaskSerializer, TokenSerializer,MirrorSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAdminUser
from rest_framework.decorators import action
from rest_framework.authtoken.models import Token
import time
import os


# Create your views here.

class ProfileViewSet(viewsets.ModelViewSet):
    # queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAdminUser]

    def get_queryset(self):
        users = Profile.objects.filter(is_active=True, is_superuser=False)
        return users

    def create(self, request, *args, **kwargs):
        data = request.data
        image = request.FILES
        user = Profile.objects.create_user(
            username=data["username"],
            email=data["email"],
            image=image["image"],
            mirror=data["mirror"]
        )
        user.set_password(data["password"])
        user.save()

        return Response(ProfileSerializer(user).data)


    def update(self, request, *args, **kwargs):
        data = request.data
        user = Profile.objects.get(pk=self.get_object().id)
        user.username = data["username"]
        user.email = data["email"]
        if "pbkdf2_sha256$" not in data["password"]:
            user.set_password(data["password"])
        user.save()
        return Response(ProfileSerializer(user).data)

    @action(methods=["POST"],detail=False)
    def uploadPhotos(self,request):
        images = dict(request.FILES)
        data = request.data
        chfama = os.listdir("../classifier/db/")
        if data["name"].lower() not in chfama:
            os.mkdir(f"../classifier/db/{data['name']}")
        if "representations_vgg_face.pkl" in chfama:
            os.remove("../classifier/db/representations_vgg_face.pkl")
        for image in images["image"]:
            _ , extension = image.name.split(".")
            ioimage = image.file.read()
            # we need to change this in production
            with open(f"../classifier/db/{data['name']}/{time.time()}.{extension}","wb") as f:
                f.write(ioimage)
        return Response("done")


class TaskViewSet(viewsets.ModelViewSet):
    serializer_class = TaskSerializer

    def get_queryset(self):
        tasks = Task.objects.filter(user=self.request.user)
        return tasks

    def create(self, request, *args, **kwargs):
        data = request.data
        user_id = Profile.objects.get(auth_token=self.request.auth)
        task = Task.objects.create(
            task=data["task"],
            date=data["date"],
            user=user_id
        )
        task.save()
        return Response(TaskSerializer(task).data)


class TokenViewSet(viewsets.ModelViewSet):
    serializer_class = TokenSerializer
    queryset = Token.objects.all()
    permission_classes = [IsAdminUser]

    def create(self, request, *args, **kwargs):
        return Response("l3asba",status=403)

class MirrorViewSet(viewsets.ModelViewSet):
    serializer_class = MirrorSerializer
    permission_classes = [IsAdminUser]
    queryset = Mirror.objects.all()
