<script setup lang="ts">
const navItems = [
  { icon: 'ph-gauge', label: 'Dashboard', active: true },
  { icon: 'ph-user-rectangle', label: 'Clients', active: false },
  { icon: 'ph-users-three', label: 'Employees', active: false },
  { icon: 'ph-chart-line-up', label: 'Accounting', active: false },
  { icon: 'ph-calendar-blank', label: 'Schedules', active: false },
  { icon: 'ph-gear-six', label: 'Settings', active: false },
]
</script>

<template>
  <nav class="sidebar">
    <div class="sidebar__nav">
      <ul>
        <li v-for="item in navItems" :key="item.label">
          <a
            href="#"
            :class="['sidebar__link', { 'sidebar__link--active': item.active }]"
            @click.prevent
          >
            <i :class="['ph', item.icon]"></i>
            <span>{{ item.label }}</span>
          </a>
        </li>
      </ul>
    </div>
  </nav>
</template>

<style scoped>
.sidebar {
  background: rgb(13, 44, 110);
  display: block;
  height: calc(100vh - 60px);
  left: 0;
  overflow: hidden;
  position: fixed;
  top: 60px;
  width: 85px;
  z-index: 999;
}

.sidebar__nav {
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: auto;
  text-align: center;
  width: 100%;
}

.sidebar__nav ul {
  flex-grow: 1;
  list-style: none;
  margin: 0;
  padding: 0;
}

.sidebar__link {
  align-items: center;
  color: #fff;
  cursor: default;
  display: flex;
  flex-direction: column;
  font-family: 'Roboto Flex', 'Roboto', 'Arial', 'Helvetica', sans-serif;
  font-weight: 700;
  gap: 4px;
  letter-spacing: 0;
  padding: 12px 8px;
  text-decoration: none;
}

.sidebar__link i {
  display: inline-flex;
  font-size: 24px;
  line-height: 1;
}

.sidebar__link span {
  display: block;
  font-size: 12px;
}

.sidebar__link--active {
  background: rgba(255, 255, 255, 0.12);
}

.sidebar__link:hover:not(.sidebar__link--active) {
  background: #e8f0fe;
  color: #1b3a6b;
}

.sidebar__link:hover:not(.sidebar__link--active) span {
  font-weight: 700;
}

@media only screen and (max-width: 1024px) {
  .sidebar {
    display: none;
  }
}
</style>
