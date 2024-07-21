<template>
  <div class="card mt-4">
    <div class="card-body">
      <h5 class="card-title">{{ school.name }}</h5>
      <div ref="map" class="map"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    school: {
      type: Object,
      required: true
    }
  },
  watch: {
    school: {
      handler() {
        if (this.map) {
          const position = { lat: parseFloat(this.school.lat), lng: parseFloat(this.school.lng) };
          this.map.setCenter(position);
          this.marker.setPosition(position);
        }
      },
      deep: true,
      immediate: true
    }
  },
  mounted() {
    this.loadGoogleMapsScript().then(() => {
      this.initMap();
    });
  },
  methods: {
    initMap() {
      const position = { lat: parseFloat(this.school.lat), lng: parseFloat(this.school.lng) };
      const mapOptions = {
        center: position,
        zoom: 14
      };
      this.map = new google.maps.Map(this.$refs.map, mapOptions);
      this.marker = new google.maps.Marker({
        position,
        map: this.map
      });
    },
    loadGoogleMapsScript() {
      return new Promise((resolve, reject) => {
        if (window.google && window.google.maps) {
          resolve();
        } else {
          const script = document.createElement('script');
          script.src = `https://maps.googleapis.com/maps/api/js?key=${process.env.VUE_APP_GOOGLE_MAPS_API_KEY}`;
          script.async = true;
          script.defer = true;
          script.onload = resolve;
          script.onerror = reject;
          document.head.appendChild(script);
        }
      });
    },
  }
};
</script>

<style scoped>
.map {
  width: 100%;
  height: 400px;
}
</style>
