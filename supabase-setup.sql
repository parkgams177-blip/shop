-- 프리마켓 장바구니 테이블
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 Run 을 누르세요. (한 번만 실행)

-- 1. 회원마다 장바구니 한 줄씩 저장
create table if not exists public.carts (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  items jsonb not null default '[]'::jsonb,   -- 담은 상품 목록 [{name, price, count}, ...]
  updated_at timestamptz not null default now()
);

-- 2. 보안 켜기: 로그인한 사람은 "자기 장바구니"만 보고 고칠 수 있음
alter table public.carts enable row level security;

-- (여러 번 실행해도 되도록 기존 규칙은 지우고 다시 만듦)
drop policy if exists "own cart select" on public.carts;
drop policy if exists "own cart insert" on public.carts;
drop policy if exists "own cart update" on public.carts;

create policy "own cart select" on public.carts
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "own cart insert" on public.carts
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "own cart update" on public.carts
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- 3. 로그인한 사용자에게 테이블 사용 권한 주기
grant select, insert, update on public.carts to authenticated;
