from django.contrib import admin
from django.urls import path,include
from rest_framework import routers
from core.views import ProfileViewSet,TaskViewSet,TokenViewSet,MirrorViewSet,ObtainAuthToken,EmailViewSet,MusicViewSet
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.authtoken.views import obtain_auth_token

router = routers.DefaultRouter()
router.register('users', ProfileViewSet,basename="users")
router.register('tasks', TaskViewSet,basename="tasks")
router.register('tokens', TokenViewSet,basename="tokens")
router.register('mirrors', MirrorViewSet,basename="mirrors")
router.register('emails', EmailViewSet,basename="emails")
router.register('musics', MusicViewSet,basename="playlist")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('login/', ObtainAuthToken.as_view())
]

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
