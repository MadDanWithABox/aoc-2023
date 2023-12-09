<template>
  <div id="app">
    <textarea v-model="userInput" rows="5" cols="30" placeholder="Enter your input"></textarea>
    <button @click="solve">Click me</button>
    <p :style="{ color: 'green' }">{{ result }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import axios from 'axios';

export default defineComponent({
  data() {
    return {
      userInput: '',
      result: 0,
    };
  },
  methods: {
    async solve() {
      try {
        const response = await axios.post('http://localhost:8888/solve', {
          input: this.userInput,
        });

        const winnings = response.data.result;

        // Update the component's state to display the result
        this.result = winnings;
      } catch (error) {
        console.error('Error:', error);
      }
    },
  },
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

textarea {
  font-size: 16px;
  padding: 10px;
  margin-bottom: 10px;
}

button {
  font-size: 16px;
  padding: 10px 20px;
  cursor: pointer;
}

p {
  font-size: 18px;
  margin-top: 20px;
}
</style>
