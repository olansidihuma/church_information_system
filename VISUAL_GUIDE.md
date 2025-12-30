# Homepage Enhancement - Visual Guide

## Homepage Layout Structure

```
┌─────────────────────────────────────────────┐
│  🏛️ Church Info              [Login] 🔐    │  <- App Bar
├─────────────────────────────────────────────┤
│                                             │
│  ╔═════════════════════════════════════╗   │
│  ║   Selamat Datang di Gereja Kami    ║   │  <- Banner Carousel
│  ║  Bergabunglah dalam ibadah dan...  ║   │     (Auto-rotating)
│  ╚═════════════════════════════════════╝   │
│         ● ● ○  <- Carousel indicators      │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  ┌────────┐  ┌────────┐  ┌────────┐       │
│  │  ℹ️     │  │  📅    │  │  👤    │       │  <- Quick Actions
│  │ Info   │  │Schedule│  │Register│       │
│  └────────┘  └────────┘  └────────┘       │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  📅 Jadwal Ibadah                          │  <- Schedule Section
│  Bergabunglah dengan ibadah kami           │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │ 🏛️  Ibadah Minggu Pagi             │   │
│  │     Setiap minggu pukul 08.00       │   │
│  │     🕐 08:00  📍 Gedung Utama       │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │ 🏛️  Ibadah Minggu Sore             │   │
│  │     Setiap minggu pukul 17.00       │   │
│  │     🕐 17:00  📍 Gedung Utama       │   │
│  └─────────────────────────────────────┘   │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  📰 Berita & Informasi       [Lihat Semua]│  <- News Section
│  Informasi terkini dari gereja             │     (Horizontal scroll)
│                                             │
│  ┌────────┐  ┌────────┐  ┌────────┐       │
│  │ [IMG]  │  │ [IMG]  │  │ [IMG]  │       │
│  │ Natal  │  │ Retret │  │ Sosial │  -->  │
│  │ 2024   │  │ Pemuda │  │ Ministry│      │
│  └────────┘  └────────┘  └────────┘       │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  ╔═════════════════════════════════════╗   │
│  ║         👥                          ║   │  <- Call to Action
│  ║  Bergabung Dengan Kami              ║   │
│  ║  Daftar sekarang untuk mengakses... ║   │
│  ║  [  Daftar Sekarang  ]             ║   │
│  ╚═════════════════════════════════════╝   │
│                                             │
└─────────────────────────────────────────────┘
```

## Welcome Popup (First Load Only)

```
┌─────────────────────────────────────────────┐
│                                             │
│     ┌─────────────────────────────┐        │
│     │                             │        │
│     │    ┌─────────────────┐     │        │
│     │    │                 │     │        │
│     │    │      🏛️         │     │        │
│     │    │                 │     │        │
│     │    └─────────────────┘     │        │
│     │                             │        │
│     │   Selamat Datang!          │        │
│     │                             │        │
│     │   Terima kasih telah...    │        │
│     │   Temukan jadwal ibadah,   │        │
│     │   berita, dan informasi... │        │
│     │                             │        │
│     │  [  Mulai Jelajahi  ]     │        │
│     │                             │        │
│     └─────────────────────────────┘        │
│                                             │
└─────────────────────────────────────────────┘
```

## Information Page Layout

```
┌─────────────────────────────────────────────┐
│  ← Informasi & Video                        │  <- App Bar
├─────────────────────────────────────────────┤
│                                             │
│  🎬 Galeri Video                            │  <- Video Gallery
│  Tonton video ibadah dan kegiatan gereja    │
│                                             │
│  [Semua] [Ibadah] [Kesaksian] [Pengajaran] │  <- Category Filter
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │  ▶️     │  │  ▶️     │  │  ▶️     │    │  <- Video Grid
│  │ [40:00] │  │ [15:00] │  │ [30:00] │    │     (Responsive)
│  │ Kasih   │  │ Mujizat │  │ Hidup   │    │
│  │ Sejati  │  │ Sembuh  │  │ Iman    │    │
│  └─────────┘  └─────────┘  └─────────┘    │
│                                             │
│  ┌─────────┐                                │
│  │  ▶️     │                                │
│  │ [10:00] │                                │
│  │ Retret  │                                │
│  │ 2024    │                                │
│  └─────────┘                                │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  📰 Berita Terkini                         │  <- Latest News
│  Informasi dan pengumuman gereja           │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │        [Image Placeholder]          │   │
│  │                                     │   │
│  │  [ANNOUNCEMENT]                     │   │
│  │  Kebaktian Natal 2024              │   │
│  │  Kebaktian Natal akan...           │   │
│  │  📅 28 Dec 2024                    │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │        [Image Placeholder]          │   │
│  │                                     │   │
│  │  [EVENT]                            │   │
│  │  Retret Pemuda                      │   │
│  │  Retret pemuda akan...              │   │
│  │  📅 29 Dec 2024                    │   │
│  └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘
```

## Color Palette

### Primary Colors
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│  #8B9EE8   │  │  #A48BC4   │  │  #FF9AA2   │
│  Primary   │  │ Secondary  │  │   Accent   │
│ Soft Blue  │  │   Soft     │  │   Soft     │
│  Purple    │  │  Lavender  │  │   Coral    │
└────────────┘  └────────────┘  └────────────┘
```

### Additional Colors
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│  #FFCAA2   │  │  #B5EAD7   │  │  #FFE4B5   │
│ Soft Pink  │  │ Soft Mint  │  │Soft Yellow │
└────────────┘  └────────────┘  └────────────┘
```

### Text Colors
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│  #4A5568   │  │  #9CA3AF   │  │  #FAFBFD   │
│  Primary   │  │ Secondary  │  │ Background │
│    Text    │  │    Text    │  │            │
└────────────┘  └────────────┘  └────────────┘
```

## Component Styles

### Banner Carousel
- **Height**: 200px
- **Border Radius**: 16px
- **Shadow**: 10px blur, 5px offset
- **Gradient**: Primary → Secondary
- **Auto-play**: 5 seconds
- **Animation**: fastOutSlowIn, 800ms

### Schedule Cards
- **Border Radius**: 16px
- **Shadow**: 10px blur, 2px offset
- **Icon Size**: 30px in 60x60 container
- **Icon Background**: Primary 10% opacity
- **Padding**: 16px all around

### News Cards
- **Width**: 280px (horizontal scroll)
- **Image Height**: 140px
- **Border Radius**: 16px
- **Shadow**: 10px blur, 2px offset
- **Text**: 2 lines max with ellipsis

### Video Cards
- **Thumbnail Height**: 160px
- **Border Radius**: 16px
- **Duration Badge**: Bottom-right, black87
- **Category Badge**: Top-left, accent color
- **Grid**: 1-4 columns (responsive)

### Quick Action Buttons
- **Border Radius**: 16px
- **Border**: 2px solid
- **Padding**: 16px
- **Icon Size**: 32px
- **Background**: Color 30% opacity

### Call to Action
- **Border Radius**: 20px
- **Shadow**: 15px blur, 5px offset
- **Gradient**: Primary → Secondary
- **Button**: White background, 32px horizontal padding
- **Icon Size**: 48px

## Responsive Breakpoints

```
Mobile (< 600px)
├─ 1 column video grid
├─ Full width banners
├─ Stacked quick actions
└─ Single column news

Tablet (600-800px)
├─ 2 column video grid
├─ Wider banners
├─ Better spacing
└─ Larger touch targets

Desktop (800-1200px)
├─ 3 column video grid
├─ Multi-column layouts
├─ Optimized for mouse
└─ Better visual hierarchy

Large Desktop (> 1200px)
├─ 4 column video grid
├─ Wider content areas
├─ Maximum width constraints
└─ Enhanced spacing
```

## User Interactions

### Banner Carousel
1. **Auto-play**: Rotates every 5 seconds
2. **Swipe**: Left/right to navigate manually
3. **Tap**: Can be configured to navigate to action URL

### Welcome Popup
1. **First Load**: Shows automatically
2. **Button Tap**: Closes popup
3. **Subsequent Loads**: Does not show

### Quick Actions
1. **Information**: → Navigate to `/information`
2. **Schedule**: → Scroll to schedule section (or navigate)
3. **Register**: → Navigate to `/register`

### Video Cards
1. **Tap**: Opens video URL in browser/YouTube app
2. **Category Filter**: Filters videos by category
3. **All Category**: Shows all videos

### News Cards
1. **Horizontal Scroll**: Swipe left/right
2. **Tap**: Can navigate to detail page (future)
3. **"Lihat Semua"**: Navigate to information page

## Animation Timings

- **Carousel Transition**: 800ms (fastOutSlowIn)
- **Page Transition**: Default GetX animation
- **Card Hover** (web/desktop): 200ms
- **Button Press**: 100ms
- **Popup Fade**: 300ms

## Accessibility Features

### Touch Targets
- Minimum 48x48 dp for all interactive elements
- Adequate spacing between elements
- Clear visual feedback on interaction

### Text Contrast
- Primary text on white: 4.5:1 (WCAG AA)
- Secondary text: Lighter but readable
- White text on gradients: High contrast

### Visual Feedback
- Loading indicators for async operations
- Empty states with clear messages
- Error states with actionable text

## Development Notes

### State Management
- Uses GetX reactive programming
- Observable variables with `.obs`
- Obx widgets for reactive UI updates

### Data Flow
```
Controller
    ↓
  Mock Data
    ↓
Observable List
    ↓
  Obx Widget
    ↓
 UI Updates
```

### Navigation
```
Home Screen
  ├─→ Login Screen (App bar button)
  ├─→ Register Screen (Quick action, CTA)
  ├─→ Information Screen (Quick action, News button)
  └─→ [Other screens via login]

Information Screen
  └─→ External Browser (Video tap)
```

## Testing Scenarios

### Homepage
✅ Initial load shows welcome popup
✅ Popup shows only once
✅ Banner carousel auto-rotates
✅ Banner carousel is swipeable
✅ Quick actions navigate correctly
✅ Schedule displays or shows empty state
✅ News scrolls horizontally
✅ Pull-to-refresh works
✅ CTA button navigates to register

### Information Page
✅ Video grid loads
✅ Category filters work
✅ Video cards are tappable
✅ Videos open in browser
✅ News section displays
✅ Responsive layout works
✅ Back button returns to home

### Responsive Testing
✅ Mobile portrait (< 600px)
✅ Mobile landscape
✅ Tablet portrait (600-800px)
✅ Tablet landscape
✅ Desktop (> 800px)
✅ Large desktop (> 1200px)

---

**Note**: All visual elements use gradient placeholders instead of images for immediate functionality without asset dependencies.
