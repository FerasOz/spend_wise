-- Keep the local schema aligned with the column created in the Supabase dashboard.
alter table public.profiles
  add column if not exists email text;

-- Create the profile on the database side. This works even when email
-- confirmation is enabled and the Flutter client has no authenticated session.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name'
  );

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();
