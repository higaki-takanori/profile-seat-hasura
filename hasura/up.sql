SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.room_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    profile_title text NOT NULL,
    "order" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.room_user (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    user_id text NOT NULL,
    seat_order text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    admin_user_id text NOT NULL,
    title text NOT NULL,
    group_row integer NOT NULL,
    group_column integer NOT NULL,
    seat_row integer NOT NULL,
    seat_column integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.user_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id text NOT NULL,
    room_id uuid NOT NULL,
    "order" integer NOT NULL,
    profile_title text NOT NULL,
    profile_content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.users (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE ONLY public.room_profiles
    ADD CONSTRAINT room_profiles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.room_profiles
    ADD CONSTRAINT room_profiles_room_id_order_key UNIQUE (room_id, "order");
ALTER TABLE ONLY public.room_user
    ADD CONSTRAINT room_user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.room_user
    ADD CONSTRAINT room_user_room_id_seat_order_key UNIQUE (room_id, seat_order);
ALTER TABLE ONLY public.room_user
    ADD CONSTRAINT room_user_user_id_room_id_key UNIQUE (user_id, room_id);
ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_room_id_order_key UNIQUE (user_id, room_id, "order");
CREATE TRIGGER set_public_room_profiles_updated_at BEFORE UPDATE ON public.room_profiles FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_room_profiles_updated_at ON public.room_profiles IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_room_user_updated_at BEFORE UPDATE ON public.room_user FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_room_user_updated_at ON public.room_user IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_rooms_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_rooms_updated_at ON public.rooms IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_profiles_updated_at ON public.user_profiles IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_user_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_updated_at ON public.users IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.room_profiles
    ADD CONSTRAINT room_profiles_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public.room_user
    ADD CONSTRAINT room_user_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public.room_user
    ADD CONSTRAINT room_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
