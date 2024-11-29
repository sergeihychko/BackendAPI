from django.contrib import admin
from database.models import Attendant
from base64 import b16encode


@admin.register(Attendant)
class AttendantAdmin(admin.ModelAdmin):
    list_display = ('ticket_id', 'nfc_id_decoded', 'discord', 'is_crew', 'is_valid')

    def nfc_id_decoded(self, obj):
        return b16encode(obj.nfc_id).decode()
