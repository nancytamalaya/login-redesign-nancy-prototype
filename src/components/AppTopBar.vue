<script setup lang="ts">
import alayacareLogo from '@/assets/alayacare-logo-white.svg'
import alayacareLogoA from '@/assets/alayacare-logo-a.svg'
</script>

<template>
  <header class="topbar">
    <a class="topbar-logo__link" href="#">
      <picture>
        <source media="(min-width: 1024px)" :srcset="alayacareLogo" />
        <img alt="AlayaCare" class="topbar-logo" :src="alayacareLogoA" />
      </picture>
    </a>

    <div class="topbar__search">
      <i class="ph ph-magnifying-glass topbar__search-icon"></i>
      <input
        class="topbar__search-input"
        type="text"
        placeholder="Search..."
        readonly
      />
      <span class="topbar__search-shortcut">Ctrl+K</span>
    </div>

    <div class="topbar__actions">
      <button type="button" class="topbar__icon-btn" aria-label="Notifications">
        <i class="ph ph-bell"></i>
      </button>
      <button type="button" class="topbar__icon-btn" aria-label="Messages">
        <i class="ph ph-envelope-simple"></i>
      </button>
      <button type="button" class="topbar__icon-btn" aria-label="Chat">
        <i class="ph ph-chat-circle-dots"></i>
      </button>

      <button type="button" class="topbar__user-btn">
        <span class="topbar__avatar">JD</span>
        <span class="topbar__user-info">
          <span class="topbar__user-time">10:30 AM &middot; EST</span>
          <span class="topbar__user-branch">Main Office</span>
        </span>
        <i class="ph ph-caret-down topbar__user-chevron"></i>
      </button>
    </div>
  </header>
</template>

<style scoped>
.topbar {
  align-items: center;
  background-color: rgb(13, 44, 110);
  box-sizing: border-box;
  column-gap: 10px;
  display: flex;
  height: 60px;
  left: 0;
  overflow: hidden;
  padding: 0 15px;
  position: fixed;
  right: 0;
  top: 0;
  width: 100%;
  z-index: 1000;
}

.topbar-logo__link {
  align-items: center;
  display: flex;
  flex-shrink: 0;
  font-size: 0;
  justify-content: center;
  line-height: 1;
  min-width: 85px;
}

.topbar-logo {
  flex-shrink: 0;
  height: 25px;
  width: 32px;
}

@media (min-width: 1024px) {
  .topbar-logo {
    height: 36px;
    width: 120px;
  }
}

.topbar__search {
  align-items: center;
  background-color: rgba(255, 255, 255, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  flex: 1;
  gap: 8px;
  height: 36px;
  max-width: 480px;
  padding: 0 12px;
}

.topbar__search-icon {
  font-size: 16px;
}

.topbar__search-input {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: default;
  flex: 1;
  font-size: 14px;
  outline: none;
}

.topbar__search-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.topbar__search-shortcut {
  background-color: rgba(255, 255, 255, 0.15);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.6);
  font-family: 'SFMono-Regular', 'Consolas', 'Liberation Mono', 'Menlo', monospace;
  font-size: 11px;
  padding: 2px 6px;
  white-space: nowrap;
}

@media (max-width: 699px) {
  .topbar__search {
    display: none;
  }
}

.topbar__actions {
  align-items: center;
  column-gap: 4px;
  display: flex;
  margin-left: auto;
  min-width: 0;
}

.topbar__icon-btn {
  align-items: center;
  background-color: transparent;
  border: none;
  border-radius: 6px;
  color: #fff;
  cursor: default;
  display: inline-flex;
  height: 36px;
  justify-content: center;
  padding: 0;
  transition: background-color 0.2s;
  width: 36px;
}

.topbar__icon-btn i {
  font-size: 22px;
  line-height: 1;
}

.topbar__icon-btn:hover {
  background-color: rgba(255, 255, 255, 0.15);
}

@media (max-width: 699px) {
  .topbar__icon-btn {
    display: none;
  }
}

.topbar__user-btn {
  align-items: center;
  background-color: transparent;
  border: none;
  border-radius: 8px;
  color: #fff;
  cursor: default;
  display: flex;
  gap: 8px;
  margin-left: 4px;
  max-width: 220px;
  min-width: 0;
  overflow: hidden;
  padding: 4px 12px 4px 4px;
  transition: background-color 0.2s;
}

.topbar__user-btn:hover {
  background-color: rgba(255, 255, 255, 0.15);
}

.topbar__avatar {
  align-items: center;
  background-color: #4a7fc1;
  border-radius: 50%;
  display: inline-flex;
  flex-shrink: 0;
  font-size: 13px;
  font-weight: 600;
  height: 32px;
  justify-content: center;
  width: 32px;
}

.topbar__user-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  overflow: hidden;
  text-align: left;
}

.topbar__user-time {
  font-size: 13px;
  font-weight: 500;
  white-space: nowrap;
}

.topbar__user-branch {
  color: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.topbar__user-chevron {
  font-size: 14px;
  line-height: 1;
}

@media (max-width: 840px) {
  .topbar__user-info {
    display: none;
  }
}
</style>
