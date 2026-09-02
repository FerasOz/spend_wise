-- Keep timestamps authoritative and make user-scoped sync queries fast.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

alter table public.expenses
  add column if not exists updated_at timestamptz not null default timezone('utc', now());
alter table public.categories
  add column if not exists updated_at timestamptz not null default timezone('utc', now());
alter table public.budgets
  add column if not exists updated_at timestamptz not null default timezone('utc', now());
alter table public.recurring_expenses
  add column if not exists updated_at timestamptz not null default timezone('utc', now());
alter table public.user_settings
  add column if not exists updated_at timestamptz not null default timezone('utc', now());

drop trigger if exists expenses_set_updated_at on public.expenses;
create trigger expenses_set_updated_at before update on public.expenses
  for each row execute function public.set_updated_at();
drop trigger if exists categories_set_updated_at on public.categories;
create trigger categories_set_updated_at before update on public.categories
  for each row execute function public.set_updated_at();
drop trigger if exists budgets_set_updated_at on public.budgets;
create trigger budgets_set_updated_at before update on public.budgets
  for each row execute function public.set_updated_at();
drop trigger if exists recurring_expenses_set_updated_at on public.recurring_expenses;
create trigger recurring_expenses_set_updated_at before update on public.recurring_expenses
  for each row execute function public.set_updated_at();
drop trigger if exists user_settings_set_updated_at on public.user_settings;
create trigger user_settings_set_updated_at before update on public.user_settings
  for each row execute function public.set_updated_at();

create index if not exists expenses_user_updated_at_idx
  on public.expenses (user_id, updated_at);
create index if not exists categories_user_updated_at_idx
  on public.categories (user_id, updated_at);
create index if not exists budgets_user_updated_at_idx
  on public.budgets (user_id, updated_at);
create index if not exists recurring_expenses_user_updated_at_idx
  on public.recurring_expenses (user_id, updated_at);

grant select, insert, update, delete on public.expenses to authenticated;
grant select, insert, update, delete on public.categories to authenticated;
grant select, insert, update, delete on public.budgets to authenticated;
grant select, insert, update, delete on public.recurring_expenses to authenticated;
