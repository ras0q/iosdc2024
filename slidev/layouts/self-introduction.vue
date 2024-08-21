<template>
  <div class="slidev-layout default">
    <div class="grid grid-cols-[1fr_2fr] gap-16">
      <div class="grid grid-place-items-center">
        <div class="mb-4 w-full aspect-ratio-square bg-orange-3 rounded-full"></div>
        <div class="text-6xl font-bold">Ras</div>
        <a class="font-mono" href="https://ras0q.com">ras0q.com</a>
        <div class="text-size-4xl">
          <mdi-language-go class="text-#5DC9E2" />
          <mdi-language-swift class="text-#f05138" />
          <mdi-language-typescript class="text-#3178C6" />
        </div>
      </div>

      <div>
        <slot />
      </div>
    </div>
  </div>
</template>
