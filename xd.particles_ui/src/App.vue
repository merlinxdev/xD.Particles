<template>
  <div v-if="main_box" :class="{ ['main-box'] : true , ['box-hide'] : Animation.fade_out } ">
    <div class="box-title">Particle Effect V.1.0</div>
    <div class="box-body">
      <div class="flex">
        <span
          >Dict :
          <font class="highlightText">{{ particle.particleDict }}</font></span
        >
        <span
          >Name :
          <font class="highlightText">{{ particle.particleName }}</font></span
        >
      </div>
    </div>
    <div class="box-body">
      <div class="key-controller">
        <div class="btn" @click="prev()"><</div>
        <div class="btn" @click="next()">></div>
        <div class="btn" @click="play()">
          {{ !autoplay ? "เล่นอัตโนมัติ" : "หยุด" }}
        </div>
        <div class="btn" @click="copyTo()">คัดลอกข้อความ</div>
        <div class="btn" @click="particle_swtich()">{{ !particle_play ? "เปิดเอฟเฟค" : "หยุดเอฟเฟค" }}</div>
      </div>
      <span class="credit">
        Made By <font class="credit-font">&nbsp;xd studio</font>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      Animation: {
        fade_out: false,
      },
      main_box: false,
      autoplay: false,
      particle_play: false,
      particle: {
        particleDict: "core",
        particleName: "water_splash_sub_wade",
      },
    };
  },
  methods: {
    play() {
      this.autoplay = !this.autoplay;
      this.sendLuaFetch("AUTO_PARTICLE", { autoplay: this.autoplay });
    },
    prev() {
      this.sendLuaFetch("PREV_PARTICLE", {});
    },
    next() {
      this.sendLuaFetch("NEXT_PARTICLE", {});
    },
    particle_swtich() {
      this.particle_play = !this.particle_play;
      this.sendLuaFetch("PLAY_PARTICLE", { particle_play: this.particle_play });
    },
    copyTo() {
        const text = `Dict : ${this.particle.particleDict} Name : ${this.particle.particleName}`;

        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'absolute';
        textArea.style.left = '-9999px';
        document.body.appendChild(textArea);

        textArea.select();
        try {
          const successful = document.execCommand('copy');
          if (successful) {
            this.sendLuaFetch("COPY_TEXT_SUCCESS", {});
          } else {
            console.error('Failed to copy text');
          }
        } catch (err) {
          console.error('Error copying text: ', err);
        } finally {
          document.body.removeChild(textArea);
        }
    },
    sendLuaFetch(type, data) {
      let requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      };
      fetch(`https://xD.Particles/${type}`, requestOptions);
    },
    openUI() {
      this.main_box = true;
    },
    closeUI() {
      this.Animation.fade_out = true;
      setTimeout(() => {
        this.main_box = false;
        this.Animation.fade_out = false;
      }, 2000);
    },
    async onMessage(event) {
      let data = event.data;
      if (data.type == "XD_NUI_SHOW") {
        if (data.data.ui) {
          this.openUI();
        } else {
          this.closeUI();
        }
      }
      if (data.type == "XD_NUI_UPDATE") {
        this.particle.particleDict = data.data.dict;
        this.particle.particleName = data.data.name;
      }
    },
    onKeyup(event) {
      if (event.keyCode == 27) {
        if(this.main_box){
          this.closeUI()
          this.sendLuaFetch("CLOSE_MENU", {});
        }
      }
    },
  },
  mounted() {
    window.addEventListener("message", this.onMessage);
    window.addEventListener("keyup", this.onKeyup);
  },
};
</script>
