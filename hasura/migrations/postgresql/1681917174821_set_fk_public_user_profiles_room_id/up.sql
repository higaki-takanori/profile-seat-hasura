alter table "public"."user_profiles"
  add constraint "user_profiles_room_id_fkey"
  foreign key ("room_id")
  references "public"."rooms"
  ("id") on update restrict on delete cascade;
