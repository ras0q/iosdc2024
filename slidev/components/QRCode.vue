<script setup lang="ts">
import VueQrcode from '@chenfengyuan/vue-qrcode';

const props = defineProps({
  value: String,
  width: {
    type: Number,
    default: 100
  },
  height: {
    type: Number,
    default: 100
  }
})
</script>

<template>
  <VueQrcode :value="props.value" :options="{
    width: props.width,
    height: props.height
  }" />
</template>
