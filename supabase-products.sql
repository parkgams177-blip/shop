-- 프리마켓 상품 테이블 + 상품 15개 (처음 설치용)
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 Run 을 누르세요.
-- 다시 실행해도 괜찮아요. 이미 있는 상품은 건드리지 않아요. (대시보드에서 고친 가격 유지)

-- 1. 상품 테이블 만들기
create table if not exists public.products (
  id bigint generated always as identity primary key,
  category text not null,          -- 카테고리 코드 (wash, inside, safety)
  category_name text not null,     -- 카테고리 이름 (세차용품 등)
  name text not null unique,       -- 상품명
  price integer not null,          -- 판매가 (할인 후)
  original_price integer not null, -- 할인 전 가격
  image_url text not null,         -- 상품 사진 주소
  sort_order integer not null default 0,  -- 보여줄 순서
  created_at timestamptz not null default now()
);

-- 2. 할인율 칸은 두지 않음 (쇼핑몰 화면에서 가격으로 자동 계산)
--    예전에 만든 discount_rate 칸이 남아 있으면 지우기
alter table public.products drop column if exists discount_rate;

-- 3. 보안: 누구나 상품 "보기"만 가능 (추가/수정/삭제는 대시보드에서만)
alter table public.products enable row level security;

drop policy if exists "anyone can read products" on public.products;
create policy "anyone can read products" on public.products
  for select to anon, authenticated
  using (true);

grant select on public.products to anon, authenticated;

-- 4. 상품 15개 넣기 (할인율은 자동 계산되므로 넣지 않음)
insert into public.products
  (category, category_name, name, price, original_price, image_url, sort_order)
values
  ('wash',   '세차용품',      '극세사 세차 스펀지',   8900,  12000, 'https://images.unsplash.com/photo-1694678505383-676d78ea3b96?w=400&h=300&fit=crop', 1),
  ('wash',   '세차용품',      '거품 카샴푸',         11200,  16000, 'https://images.unsplash.com/photo-1633014041037-f5446fb4ce99?w=400&h=300&fit=crop', 2),
  ('wash',   '세차용품',      '휠 세척 브러시',       14900,  20000, 'https://images.unsplash.com/photo-1565689876697-e467b6c54da2?w=400&h=300&fit=crop', 3),
  ('wash',   '세차용품',      '유리 발수 코팅제',      9800,  14000, 'https://images.unsplash.com/photo-1652994994973-05db53f13034?w=400&h=300&fit=crop', 4),
  ('wash',   '세차용품',      '흡수 드라잉 타월',     13500,  18000, 'https://images.unsplash.com/photo-1761934658331-2e00b20dc6c6?w=400&h=300&fit=crop', 5),
  ('inside', '실내용품',      '우드캡 차량용 방향제', 10900,  15000, 'https://images.unsplash.com/photo-1768983298275-942312c9b446?w=400&h=300&fit=crop', 6),
  ('inside', '실내용품',      '폭신 목쿠션',         15400,  22000, 'https://images.unsplash.com/photo-1654801816121-2beac3d9af53?w=400&h=300&fit=crop', 7),
  ('inside', '실내용품',      '차량용 컵홀더',        6900,   9000, 'https://images.unsplash.com/photo-1758347965959-0d3601b55fe5?w=400&h=300&fit=crop', 8),
  ('inside', '실내용품',      '트렁크 정리함',       21900,  29000, 'https://images.unsplash.com/photo-1688054004445-7c9108eb4005?w=400&h=300&fit=crop', 9),
  ('inside', '실내용품',      '가죽 시트 커버',      24500,  35000, 'https://images.unsplash.com/photo-1605647381739-9bba88b1c5d1?w=400&h=300&fit=crop', 10),
  ('safety', '안전·전자용품', '휴대폰 거치대',       17500,  25000, 'https://images.unsplash.com/photo-1717007873182-7cc5d673cbff?w=400&h=300&fit=crop', 11),
  ('safety', '안전·전자용품', '비상용 LED 손전등',   12900,  18000, 'https://images.unsplash.com/photo-1561916960-dea3b9b0355a?w=400&h=300&fit=crop', 12),
  ('safety', '안전·전자용품', '고속 충전 케이블',    13900,  19000, 'https://images.unsplash.com/photo-1572721546624-05bf65ad7679?w=400&h=300&fit=crop', 13),
  ('safety', '안전·전자용품', '2채널 블랙박스',     119000, 159000, 'https://images.unsplash.com/photo-1765959106936-851735565c12?w=400&h=300&fit=crop', 14),
  ('safety', '안전·전자용품', '차량용 소화기',       24900,  32000, 'https://images.unsplash.com/photo-1625958936686-a9343dc35b5b?w=400&h=300&fit=crop', 15)
on conflict (name) do nothing;
