base16Scheme: with base16Scheme; ''
  migration_level: 12
  general:
    displayName: Morgan
    language: en-GB
    keybindings:
      search:
        - ctrlKey
        - KeyF
    collapsedItems: []
    closeToTray: false
    promptOnClose: false
    warnBeforeQueueOverride: false
    startupPage: /am/home
  audio:
    volume: 1
    volumeStep: 0.05
    exponentialVolume: false
    maxVolume: 1
    volumeDisplaySPL:
      enabled: false
      calibration: 90
    equalizer:
      enabled: true
      preset: default
      frequencies:
        - 32
        - 63
        - 125
        - 250
        - 500
        - 1000
        - 2000
        - 4000
        - 8000
        - 16000
      gain:
        - 0
        - 0
        - 0
        - 0
        - 0
        - 0
        - 0
        - 0
        - 0
        - 0
      Q:
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
        - 0.707
      mix: 1
      vibrantBass: 0
      userGenerated: false
    showBitrateBadge: true
    ciderAudio:
      enabled: true
      showInToolbar: false
      showBadges: false
      ciderPPE: true
      ciderPPE_value: MAIKIWI
      staticOptimizer:
        state: false
        lock: false
      lastNode: n1
      firstNode: n1
      opportunisticCorrection_state: OFF
      atmosphereRealizer1: false
      atmosphereRealizer1_value: NATURAL_STANDARD
      atmosphereRealizer2: false
      atmosphereRealizer2_value: NATURAL_STANDARD
      spatial: false
      spatialProfile: maikiwinew
    normalization: true
    podcastsPlaybackSpeed: 1
  visual:
    appearance: dark
    layoutType: maverick-if
    layoutView: HHh LpR FFf
    useAdaptiveColors: false
    adaptiveColorPercent: 100
    viewTransitions: true
    prefersReducedMotion: false
    hardwareAcceleration: default
    windowSize:
      - 1024
      - 640
    windowPosition:
      - 0
      - 0
    titleBarStyle: native
    artworkLoadingMethod: lazy
    artworkBlurMap:
      fpsLimit: 30
    backgroundBlurMap:
      enabled: false
      src: ""
      filter:
        blur: 128
        saturate: 200
        brightness: 10
        contrast: 100
    immersive:
      useAnimatedBackground: true
      useAnimatedArtwork: true
      backgroundType: default
      layoutType: sonoma
      layoutTypePortrait: sonoma
      maxBackgroundBrightness: 50
      useBackgroundBPM: true
      startFullscreen: false
      filter:
        saturate: 180
        contrast: 1.3
    customCSS: ""
    lyricSpeedMultiplier: 1
    scalingFactor: 1
    fonts:
      main: default
      lyrics: default
    overlayDrawer: false
    scrollbarType: default
    vibrancyMode: mica
    vibrancyModeLight: tabbed
    acrylicDarkValue: 0.5
    hiresImages: false
    pauseAnimatedOnBlur: true
    sweetener:
      useImmersiveBG: false
      immersive_bg_fps: 15
      immersive_bg_filter:
        blur: 128
        saturate: 100
        brightness: 100
        contrast: 100
    ui_custom:
      customAccentColor: true
      customAccentColorValue: "#${base0D}"
      customTintColor: false
      customTintColorValue: "#${base06}"
      customTintColorRatio: 0.5
    ultraWide: false
    sizing: default
    transparency: false
  ui:
    chromeTopWidget: search
    leftDrawerOverlay: false
    windowControlOverride: default
    mainMenuPosition: right
    forceMPWindowControls: false
  components:
    AMProgressBar:
      iOSStyle: true
      useAccentColor: true
    AMVolumeSlider:
      iOSStyle: true
    HeaderSearch:
      NoRedirectOnSelect: false
    ImmersiveSonoma:
      UseRadialMask: true
      UseAlternateMask: false
    Immersive:
      StartTab: lyrics
      MaxLyricSize: 70
      KeepCompletedLyrics: false
      ControlsTimeout: 1
      ArtworkHighlight: true
      HideSidePanelWhenNoLyrics: true
      EnableTransparency: false
      TransparencyValue: 1
      CustomImagePath: ""
      CustomImageFilter:
        blur: 0
        saturate: 100
        brightness: 100
        contrast: 100
      CustomImageMixValue: 0.5
    SimpleImmersiveBGArtwork:
      UseMask: true
      filter:
        blur: 0
        saturate: 280
        brightness: 50
        contrast: 100
    MediaItem:
      AnimateArtworkOnHover: false
    MediaItemArtwork:
      DisableFadeIn: true
      Highlights: true
    HLSVideo:
      NVFix: false
    PlaylistsPage:
      iOSLayout: true
      iOSLayoutAlways: true
      editorialLayout: false
      editorialPreference:
        - bannerUber
        - storeFlowcase
        - subscriptionHero
        - originalFlowcaseBrick
    CompactSidebar:
      size: small
      align: top
    Window:
      TitleBarControlSize: large
    ListItemProvider:
      fetchAttributes: true
    MiniPlayer:
      AnimatedArtwork: false
    MojaveLayouts:
      PlayerType: glass
      ShowQuickActions: true
    AMPLCD:
      Style: glass
    RichAlbumGrid:
      ScrollToPosition: top
      DisableScrollAnimation: false
    ThreeDQueue:
      Style: default
    SidebarProfile:
      Enabled: false
      HasMainMenu: true
      HandleVisible: true
      NameVisible: true
    ImmersiveSingAlong:
      CustomCSS: ""
      CustomCSSEnabled: false
      PlayerIdleBehavior: hide
  caching:
    LibraryAlbums: true
    Content: true
    ArtistChips: true
    Home: true
  lyrics:
    timeOffset: 0
    thirdPartySources: true
    scaleOnAny: false
    characterFlow: true
    singLyricsEverywhere: true
    translationEnabled: false
    translationLanguage: en
    style:
      enabled: false
      easingFunction: ""
      easingFunctionImmersive: ""
      duration: 0.5
      durationImmersive: 1
  advanced:
    flags: []
    disableLogging: false
    chromiumFlags: []
    enableMediaItemInspect: false
    switchPreset: default
    testing:
      steamDeck: false
      gameMode: false
      themeManager: false
      podcasts: false
      musicVideos: false
      forceExplicit: false
    devTools: false
    mprisEnabled: true
  connectivity:
    playbackNotifications: false
    playbackNotificationType: native
    webSockets:
      enabled: false
    rpcServer:
      enabled: false
    apiTokensRequired: true
    apiTokens: []
    discord:
      enabled: false
      client: Cider
      clearOnPause: true
      stateFormat: by {artist}
      detailsFormat: "{title}"
      timestampFormat: remaining
      buttons: []
      useAnimatedArtwork: false
      showArtist: true
    nanoleaf:
      credentials: []
  appleMusic:
    enabled: true
    drmSystem: default
    privateEnabled: false
    animatedArtwork: true
    catalogAnimatedArtwork: false
    animatedArtworkLevel: 7
    showUserInfo: true
    seamlessAudioTransitions: true
    showStorefrontWarning: true
    popularityThreshold: 0.6
    backgroundRefreshTime: 60
    showBPM: false
    language: en-GB
    storefront: gb
    noPlayingAction: shuffle-library-songs
    lyrics:
      singLyrics: true
    libraryAlbums:
      sortBy: none
      order: asc
    librarySongs:
      sortBy: artist
      order: asc
      showArtwork: false
      queueLimit: 100
      itemSize: default
    libraryPlaylists:
      sortBy: none
      order: asc
    home:
      pinnedItems: []
      pinnedItemsViewType: list
      sectionsOrder:
        - pinnedItems
        - recentlyPlayed
        - artistFeed
        - madeForYou
        - fromShazam
        - friendsListeningTo
      followedArtists:
        - "954266"
        - "1527936639"
        - "1492604670"
        - "167375968"
        - "1065981054"
        - "1264818718"
        - "432942256"
        - "1168567308"
        - "179865613"
        - "42102393"
        - "80800060"
        - "1428148531"
        - "1273493034"
        - "1077454941"
        - "148662"
        - "1766632560"
        - "41334108"
        - "1178673531"
        - "791802518"
        - "258668501"
        - "14748659"
        - "1004130511"
        - "638343826"
        - "1457877216"
        - "390647681"
        - "1481783288"
        - "1355520751"
        - "118007099"
      buttonLocation: sidebar
      artwork:
        enabled: false
        url: ""
        video: false
        position: center
    browse:
      hideHeroItems: false
      moveUpLinks: false
    useAMPComponents: {}
    podcasts:
      following: []
  spotify:
    enabled: false
    playlists: []
    relationships: []
    loggedin: false
    refreshToken: ""
  casting:
    enabled: false
  connect:
    analyticsLevel: 0
    enabled: false
    authed: false
    toggles:
      core: false
      relay: false
      sync: false
      listenTogether: false
      playlists: false
    party:
      privacy: private
      limit: 5
  updates:
    updateChannel: stable
    checkForUpdates: true
  DVTCfg:
    V250: {}
''
