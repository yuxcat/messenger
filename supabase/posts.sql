create table posts (
  id integer generated always as identity,
  belongs uuid references auth.users not null,
  createdby uuid references auth.users not null,
  updated_at timestamp with time zone,
  title text,
  contents text,

  primary key (id)
  
);

alter table posts enable row level security;

create policy "Public profiles are viewable by everyone."
  on posts for select
  using ( true );

create policy "Users can insert their own profile."
  on posts for insert
  with check ( auth.uid() = createdby );

create policy "Users can update own profile."
  on posts for update
  using ( auth.uid() = createdby );

-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table posts;

-- Set up Storage!
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true);

create policy "Anyone can upload an avatar."
  on storage.objects for insert
  with check ( bucket_id = 'avatars' );
