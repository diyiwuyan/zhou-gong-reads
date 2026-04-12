-- ============================================================
-- profiles 表：存储用户昵称、最近学习书籍等信息
-- 在 Supabase Dashboard > SQL Editor 中执行
-- ============================================================

-- 1. 创建 profiles 表
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nickname TEXT,
  last_book_id INTEGER,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 开启 RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 3. RLS 策略：用户只能读写自己的 profile
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- 4. 管理员可以读所有 profiles（用于管理后台）
CREATE POLICY "Admin can read all profiles"
  ON public.profiles FOR SELECT
  USING (true);

-- 5. 触发器：新用户注册时自动创建空 profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, nickname)
  VALUES (NEW.id, split_part(NEW.email, '@', 1))
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 删除旧触发器（如果存在）
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 创建触发器
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 6. 为已有用户补充 profile（如果已有用户但没有 profile）
INSERT INTO public.profiles (id, nickname)
SELECT id, split_part(email, '@', 1)
FROM auth.users
ON CONFLICT (id) DO NOTHING;

-- 7. 为已有 profiles 表添加 last_book_id 字段（如果已执行过旧版本）
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS last_book_id INTEGER;
