-- CreateEnum
CREATE TYPE "public"."IntentName" AS ENUM ('RECOMMENDATION', 'PURCHASE_OR_TRANSACTIONAL_INTENT', 'SWITCH_SIGNAL', 'COMPLAINT', 'COMPARISONS_OR_EVALUATIONS', 'EXPRESSIONS_OF_NEED_OR_DESIRE', 'QUESTIONS_OR_INQUIRIES', 'LIFE_EVENTS_OR_TRIGGER_MOMENTS');

-- CreateEnum
CREATE TYPE "public"."CategoryName" AS ENUM ('DIRECT_SEEK', 'SWITCH_SIGNAL', 'IMPLICIT_NEED');

-- CreateTable
CREATE TABLE "public"."Post" (
    "id" TEXT NOT NULL,
    "title" TEXT,
    "text" TEXT NOT NULL,
    "uri" TEXT NOT NULL,
    "language" TEXT,
    "location" TEXT,
    "timestamp" TIMESTAMP(0) NOT NULL,
    "platformId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "processedAt" TIMESTAMP(3),

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Intent" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "name" "public"."IntentName" NOT NULL,

    CONSTRAINT "Intent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Category" (
    "id" TEXT NOT NULL,
    "name" "public"."CategoryName" NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Topic" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Topic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PostIntent" (
    "postId" TEXT NOT NULL,
    "intentId" TEXT NOT NULL,
    "confidenceScore" DOUBLE PRECISION,

    CONSTRAINT "PostIntent_pkey" PRIMARY KEY ("postId","intentId")
);

-- CreateTable
CREATE TABLE "public"."PostTopic" (
    "postId" TEXT NOT NULL,
    "topicId" TEXT NOT NULL,

    CONSTRAINT "PostTopic_pkey" PRIMARY KEY ("postId","topicId")
);

-- CreateTable
CREATE TABLE "public"."Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PostTag" (
    "postId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "PostTag_pkey" PRIMARY KEY ("postId","tagId")
);

-- CreateTable
CREATE TABLE "public"."Platform" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Platform_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "profileUrl" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Post_uri_key" ON "public"."Post"("uri");

-- CreateIndex
CREATE INDEX "Post_timestamp_idx" ON "public"."Post"("timestamp");

-- CreateIndex
CREATE INDEX "Post_uri_idx" ON "public"."Post"("uri");

-- CreateIndex
CREATE UNIQUE INDEX "Intent_name_key" ON "public"."Intent"("name");

-- CreateIndex
CREATE INDEX "Intent_name_idx" ON "public"."Intent"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Category_name_key" ON "public"."Category"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Topic_name_key" ON "public"."Topic"("name");

-- CreateIndex
CREATE INDEX "Topic_name_idx" ON "public"."Topic"("name");

-- CreateIndex
CREATE INDEX "PostIntent_confidenceScore_idx" ON "public"."PostIntent"("confidenceScore");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_key" ON "public"."Tag"("name");

-- CreateIndex
CREATE INDEX "Tag_name_idx" ON "public"."Tag"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Platform_name_key" ON "public"."Platform"("name");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "public"."User"("username");

-- AddForeignKey
ALTER TABLE "public"."Post" ADD CONSTRAINT "Post_platformId_fkey" FOREIGN KEY ("platformId") REFERENCES "public"."Platform"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Post" ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Intent" ADD CONSTRAINT "Intent_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostIntent" ADD CONSTRAINT "PostIntent_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostIntent" ADD CONSTRAINT "PostIntent_intentId_fkey" FOREIGN KEY ("intentId") REFERENCES "public"."Intent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostTopic" ADD CONSTRAINT "PostTopic_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostTopic" ADD CONSTRAINT "PostTopic_topicId_fkey" FOREIGN KEY ("topicId") REFERENCES "public"."Topic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostTag" ADD CONSTRAINT "PostTag_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PostTag" ADD CONSTRAINT "PostTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "public"."Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
