-- products 표의 discount_rate 를 "자동 계산 칸"으로 바꾸기 (한 번만 실행)
-- 가격(price)이나 원래 가격(original_price)을 고치면 할인율이 저절로 다시 계산돼요.
-- 계산식: (원래 가격 - 판매가) × 100 ÷ 원래 가격 을 반올림, 할인이 없으면 0

alter table public.products drop column if exists discount_rate;

alter table public.products
  add column discount_rate integer
  generated always as (
    case
      when original_price > 0 and price < original_price
        then round((original_price - price) * 100.0 / original_price)::integer
      else 0
    end
  ) stored;
