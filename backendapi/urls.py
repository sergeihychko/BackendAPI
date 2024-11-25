from django.urls import path, register_converter

from . import views, converters

register_converter(converters.BinaryHexConverter, "hex")

urlpatterns = [
    path("nfctag/<hex:tag>", views.scanned),
    path("test", views.api_get, name="api_get"),
]
