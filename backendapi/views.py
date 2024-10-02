from django.shortcuts import render
from django.views.decorators.http import require_POST
from django.views.decorators.cache import never_cache
from django.http import JsonResponse

from database.models import Attendant


@require_POST
@never_cache
def scanned(request, tag: bytes):
    try:
        attendant = Attendant.objects.get(tag=tag)
        # TODO: Queue event
        return JsonResponse({"valid": attendant.is_valid}, status=202)

    except Attendant.DoesNotExist:
        return JsonResponse({"error": "No such tag"}, status=404)
