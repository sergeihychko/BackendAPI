from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.views.decorators.cache import never_cache
from django.http import JsonResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from base64 import b16decode, b16encode

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


@api_view(["GET", "POST"])
def api_get(request):
    if request.method == "GET":
        return Response({"message": "GET request received"}, status=200)
    elif request.method == "POST":
        return Response({"message": "POST request received"}, status=200)


@api_view(["GET"])
def verify_ticket(request, ticket):
    # TODO: Implement ticket check
    if ticket == 'test123':
        return Response(
            {"is_valid": True}, status=status.HTTP_200_OK,
        )
    return Response(
        {"is_valid": False}, status=status.HTTP_400_BAD_REQUEST,
    )


@api_view(["POST"])
def create_attendant(request):
    ticket_id = request.data.get("ticket_id")
    nfc_id = b16decode(request.data.get("nfc_id"), casefold=True)

    if not ticket_id or not nfc_id:
        return Response(
            {"error": "ticket_id and nfc_id are required."},
            status=status.HTTP_400_BAD_REQUEST,
        )

    attendant = Attendant.objects.create(ticket_id=ticket_id, nfc_id=nfc_id)

    return Response(
        {
            "message": "Attendant created successfully.",
            "id": attendant.id,
        }
    )
