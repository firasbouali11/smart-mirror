from rest_framework import viewsets
from .models import Profile, Task, Mirror, Email,Music
from .serializers import ProfileSerializer, TaskSerializer, TokenSerializer, MirrorSerializer, AuthTokenSerializer, \
    EmailSerializer,MusicSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAdminUser
from rest_framework.decorators import action
import time
import os
from rest_framework import parsers, renderers
from rest_framework.authtoken.models import Token
from rest_framework.compat import coreapi, coreschema
from rest_framework.schemas import ManualSchema
from rest_framework.schemas import coreapi as coreapi_schema
from rest_framework.views import APIView


# Create your views here.

    
class ProfileViewSet(viewsets.ModelViewSet):
    # queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    # permission_classes = [IsAdminUser]

    def get_queryset(self):
        users = Profile.objects.filter(is_active=True, is_superuser=False)
        return users

    def create(self, request, *args, **kwargs):
        data = request.data
        image = request.FILES
        mirror = Mirror.objects.get(pk=data["mirror_id"])
        user = Profile.objects.create_user(
            username=data["username"],
            email=data["email"],
            image=image["image"],
            mirror=mirror
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
        # user.save()
        return Response(ProfileSerializer(user).data)



    
    @action(detail=False)
    def getUserData(self,request):
        user = Profile.objects.get(auth_token=self.request.auth)
        return Response(ProfileSerializer(user).data)


    @action(methods=["POST"], detail=False)
    def uploadPhotos(self, request):
        images = dict(request.FILES)
        data = request.data
        chfama = os.listdir("../classifier/db/")
        if data["name"].lower() not in chfama:
            os.mkdir(f"../classifier/db/{data['name']}")
        if "representations_vgg_face.pkl" in chfama:
            os.remove("../classifier/db/representations_vgg_face.pkl")
        for image in images["image"]:
            _, extension = image.name.split(".")
            ioimage = image.file.read()
            # we need to change this in production
            with open(f"../classifier/db/{data['name']}/{time.time()}.{extension}", "wb") as f:
                f.write(ioimage)
        return Response("done")



class EmailViewSet(viewsets.ModelViewSet):
    serializer_class = EmailSerializer

    def get_queryset(self):
        return Email.objects.filter(sender=self.request.user)

    def create(self, request, *args, **kwargs):
        data = request.data
        user_id = Profile.objects.get(auth_token=self.request.auth)
        email = Email.objects.create(
            email=data["email"],
            sender=user_id
        )
        email.save()

        return Response(EmailSerializer(email).data)


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
        return Response("l3asba", status=403)


class MirrorViewSet(viewsets.ModelViewSet):
    serializer_class = MirrorSerializer
    permission_classes = [IsAdminUser]
    queryset = Mirror.objects.all()

class MusicViewSet(viewsets.ModelViewSet):
    serializer_class = MusicSerializer

    def get_queryset(self):
        return Music.objects.filter(user=self.request.user)

    def create(self, request, *args, **kwargs):
        data = request.data
        user = Profile.objects.get(auth_token=self.request.auth)

        music = Music.objects.create(music=data["music"],user=user)

        music.save()

        return Response(MusicSerializer(music).data)

class ObtainAuthToken(APIView):
    throttle_classes = ()
    permission_classes = ()
    parser_classes = (parsers.FormParser, parsers.MultiPartParser, parsers.JSONParser,)
    renderer_classes = (renderers.JSONRenderer,)
    serializer_class = AuthTokenSerializer

    if coreapi_schema.is_enabled():
        schema = ManualSchema(
            fields=[
                coreapi.Field(
                    name="username",
                    required=True,
                    location='form',
                    schema=coreschema.String(
                        title="Username",
                        description="Valid username for authentication",
                    ),
                ),
                coreapi.Field(
                    name="password",
                    required=True,
                    location='form',
                    schema=coreschema.String(
                        title="Password",
                        description="Valid password for authentication",
                    ),
                ),
                coreapi.Field(
                    name="mirror id",
                    required=True,
                    location='form',
                    schema=coreschema.String(
                        title="mirror id",
                        description="Valid mirror ID for authentication",
                    ),
                ),
            ],
            encoding="application/json",
        )

    def get_serializer_context(self):
        return {
            'request': self.request,
            'format': self.format_kwarg,
            'view': self
        }

    def get_serializer(self, *args, **kwargs):
        kwargs['context'] = self.get_serializer_context()
        return self.serializer_class(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})
