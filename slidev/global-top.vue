<script setup lang="ts">
import QRCode from './components/QRCode.vue';

const showQRCode = process.env.NODE_ENV === 'development';
</script>

<template>
  <div class="absolute top-0 right-0">
    <QRCode v-if="showQRCode" value="https://ras0q.github.io/iosdc2024" />
  </div>
</template>
