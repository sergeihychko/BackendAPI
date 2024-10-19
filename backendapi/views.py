from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.views.decorators.cache import never_cache
from django.http import JsonResponse

from database.models import Attendant


@csrf_exempt
@require_POST
@never_cache
def scanned(request, tag: bytes):
    try:
        attendant = Attendant.objects.get(nfc_id=tag)
        # TODO: Queue event
        return JsonResponse({"valid": attendant.is_valid}, status=202)

    except Attendant.DoesNotExist:
        return JsonResponse({"error": "No such tag", "valid": False}, status=404)
