{ lib, ... }:

{
  # Shared calendar configurations for family members
  # This module provides a function to generate Thunderbird calendar settings
  # with different time format preferences

  sharedCalendars = { use24HourFormat ? true }: {
    # Auto-enable extensions
    "extensions.autoDisableScopes" = 0;

    # Calendar configuration
    "calendar.timezone.local" = "America/Chicago";
    "calendar.timezone.useSystemTimezone" = true;
    "calendar.ui.version" = 3;

    # Time format: 0 = 24-hour, 1 = 12-hour
    "calendar.date.format" = if use24HourFormat then 0 else 1;

    # Default reminder settings for events and tasks
    "calendar.alarms.default.enabled" = true;
    "calendar.alarms.default.length" = 15; # 15 minutes before
    "calendar.alarms.default.unit" = 0; # 0=minutes, 1=hours, 2=days
    "calendar.tasks.defaultstart" = "none"; # or "today", "tomorrow", "nextweek"
    "calendar.tasks.defaultdue" = "none"; # or "today", "tomorrow", "nextweek"

    # Main Calendar (Grayson's Calendar)
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.cache.enabled" = true;
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.calendar-main-in-composite" = true;
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.color" = "#3d3846";
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.disabled" = false;
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.name" = "Grayson's Calendar";
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.readOnly" = false;
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.refreshInterval" = "5";
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.suppressAlarms" = false;
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.type" = "caldav";
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.uri" = "https://calendar.graysonhead.net/ghead/58b3381d-c909-44b8-d92a-8c220c54874e/";
    "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.username" = "ghead";

    # Family Calendar
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.cache.enabled" = true;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.calendar-main-default" = true;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.calendar-main-in-composite" = true;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.color" = "#f5c211";
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.disabled" = false;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.name" = "Family Calendar";
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.readOnly" = false;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.refreshInterval" = "5";
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.suppressAlarms" = false;
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.type" = "caldav";
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.uri" = "https://calendar.graysonhead.net/ghead/438917c6-82a6-7d8e-8f5f-b01190f02147/";
    "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.username" = "ghead";

    # Grayson's Work Calendar (Cloudflare)
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.cache.enabled" = true;
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.calendar-main-in-composite" = true;
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.color" = "#ff6b35";
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.disabled" = false;
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.name" = "Grayson's Work Calendar";
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.readOnly" = true;
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.refreshInterval" = "30";
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.suppressAlarms" = false;
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.type" = "ics";
    "calendar.registry.3cf0b638-ef7c-4939-8e5f-f417c63f9035.uri" = "https://calendar.google.com/calendar/ical/ghead%40cloudflare.com/public/basic.ics";

    # Grayson's Oncall Calendar
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.cache.enabled" = true;
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.calendar-main-in-composite" = true;
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.color" = "#99ffff";
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.disabled" = false;
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.name" = "Grayson's Oncall";
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.readOnly" = true;
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.refreshInterval" = "30";
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.suppressAlarms" = false;
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.type" = "ics";
    "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.uri" = "https://cloudflare.pagerduty.com/private/c445b47257761cc27746a1d317b015851ba473084d5a3ed5c63750ff3f32efe2/feed";

    # Calendar list order (Family, Grayson's Personal, Grayson's Work, Grayson's Oncall)
    "calendar.list.sortOrder" = "f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7 c0531f6c-889f-48ca-b5c4-ceab6d55b896 3cf0b638-ef7c-4939-8e5f-f417c63f9035 b211e8d1-b459-40a1-aaf2-551362c9a426";
  };
}
