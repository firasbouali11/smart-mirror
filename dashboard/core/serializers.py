from rest_framework import serializers
from .models import Profile, Task, Mirror
from rest_framework.authtoken.models import Token


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ["id", "username", "email"]


class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = "__all__"

class TokenSerializer(serializers.ModelSerializer):
    user = ProfileSerializer(read_only=True)
    class Meta:
        model = Token
        fields = ["key","user"]

class MirrorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Mirror
        fields = "__all__"


