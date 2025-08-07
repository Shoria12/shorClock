.class public Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;
.super Landroid/appwidget/AppWidgetProvider;
.source "DigitalClockWidgetProvider.java"

# interfaces
.implements Ljava/lang/Thread$UncaughtExceptionHandler;

# direct methods
.method public constructor <init>()V
    .locals 0
    .prologue
    invoke-direct {p0}, Landroid/appwidget/AppWidgetProvider;-><init>()V
    return-void
.end method

.method private static drawClock(Landroid/content/Context;Landroid/widget/RemoteViews;)V
    .locals 8
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "views"    # Landroid/widget/RemoteViews;
    
    .prologue
    # Получаем текущее время правильным способом
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;
    move-result-object v0
    
    # Получаем часы (24-часовой формат)
    const/16 v1, 0xb
    invoke-virtual {v0, v1}, Ljava/util/Calendar;->get(I)I
    move-result v2
    
    # Получаем минуты
    const/16 v1, 0xc
    invoke-virtual {v0, v1}, Ljava/util/Calendar;->get(I)I
    move-result v3
    
    # Создаем строку времени с форматированием
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    
    # Добавляем часы с ведущим нулем
    const/16 v5, 0xa
    if-ge v2, v5, :hour_ok
    const-string v6, "0"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :hour_ok
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Добавляем двоеточие
    const-string v6, ":"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    
    # Добавляем минуты с ведущим нулем
    if-ge v3, v5, :min_ok
    const-string v6, "0"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :min_ok
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Устанавливаем время в главный TextView
    const v5, 0x7f070002
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {p1, v5, v6}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V
    
    # Обновляем день недели
    invoke-static {p0, p1, v0}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->updateDayAndDate(Landroid/content/Context;Landroid/widget/RemoteViews;Ljava/util/Calendar;)V
    
    return-void
.end method

.method private static updateDayAndDate(Landroid/content/Context;Landroid/widget/RemoteViews;Ljava/util/Calendar;)V
    .locals 9
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "views"    # Landroid/widget/RemoteViews;
    .param p2, "calendar"    # Ljava/util/Calendar;
    
    .prologue
    # Получаем день недели (1=Воскресенье, 2=Понедельник, ...)
    const/4 v0, 0x7
    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I
    move-result v1
    
    # Получаем месяц и день
    const/4 v0, 0x2
    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I
    move-result v2
    add-int/lit8 v2, v2, 0x1
    
    const/4 v0, 0x5
    invoke-virtual {p2, v0}, Ljava/util/Calendar;->get(I)I
    move-result v3
    
    # Массив дней недели (краткие названия)
    const/4 v0, 0x7
    new-array v4, v0, [Ljava/lang/String;
    const/4 v0, 0x0
    const-string v5, "Вс"
    aput-object v5, v4, v0
    const/4 v0, 0x1
    const-string v5, "Пн"
    aput-object v5, v4, v0
    const/4 v0, 0x2
    const-string v5, "Вт"
    aput-object v5, v4, v0
    const/4 v0, 0x3
    const-string v5, "Ср"
    aput-object v5, v4, v0
    const/4 v0, 0x4
    const-string v5, "Чт"
    aput-object v5, v4, v0
    const/4 v0, 0x5
    const-string v5, "Пт"
    aput-object v5, v4, v0
    const/4 v0, 0x6
    const-string v5, "Сб"
    aput-object v5, v4, v0
    
    # Устанавливаем день недели
    const v0, 0x7f07000e
    add-int/lit8 v5, v1, -0x1
    aget-object v6, v4, v5
    invoke-virtual {p1, v0, v6}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V
    
    # Создаем строку даты MM/DD
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    
    # Добавляем месяц с ведущим нулем
    const/16 v8, 0xa
    if-ge v2, v8, :month_ok
    const-string v6, "0"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :month_ok
    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Добавляем слэш
    const-string v6, "/"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    
    # Добавляем день с ведущим нулем
    if-ge v3, v8, :day_ok
    const-string v6, "0"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :day_ok
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Устанавливаем дату
    const v0, 0x7f070015
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {p1, v0, v6}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V
    
    return-void
.end method

.method private static updateViews(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    .locals 4
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "aw"    # Landroid/appwidget/AppWidgetManager;
    .param p2, "widgetIds"    # [I
    
    .prologue
    # Создаем RemoteViews
    new-instance v3, Landroid/widget/RemoteViews;
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v0
    const/high16 v1, 0x7f030000
    invoke-direct {v3, v0, v1}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V
    
    # Обновляем часы и дату
    invoke-static {p0, v3}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->drawClock(Landroid/content/Context;Landroid/widget/RemoteViews;)V
    
    # Обновляем все виджеты
    invoke-static {p1, p2, v3}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->updateWidget(Landroid/appwidget/AppWidgetManager;[ILandroid/widget/RemoteViews;)V
    
    return-void
.end method

.method private static updateWidget(Landroid/appwidget/AppWidgetManager;[ILandroid/widget/RemoteViews;)V
    .locals 3
    .param p0, "aw"    # Landroid/appwidget/AppWidgetManager;
    .param p1, "widgetIds"    # [I
    .param p2, "views"    # Landroid/widget/RemoteViews;
    
    .prologue
    if-eqz p0, :end
    if-nez p1, :loop_start
    goto :end
    
    :loop_start
    const/4 v0, 0x0
    :loop
    array-length v1, p1
    if-ge v0, v1, :end
    aget v2, p1, v0
    invoke-virtual {p0, v2, p2}, Landroid/appwidget/AppWidgetManager;->updateAppWidget(ILandroid/widget/RemoteViews;)V
    add-int/lit8 v0, v0, 0x1
    goto :loop
    
    :end
    return-void
.end method

.method public static updateClock(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;)V
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "aw"    # Landroid/appwidget/AppWidgetManager;
    
    .prologue
    invoke-static {p0}, Lcom/sec/android/widgetapp/digitalclock/SharedManager;->getPrefIDs(Landroid/content/Context;)[I
    move-result-object v0
    invoke-static {p0, p1, v0}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->updateViews(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    return-void
.end method

# virtual methods
.method public onUpdate(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "appWidgetManager"    # Landroid/appwidget/AppWidgetManager;
    .param p3, "appWidgetIds"    # [I
    
    .prologue
    invoke-super {p0, p1, p2, p3}, Landroid/appwidget/AppWidgetProvider;->onUpdate(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    
    array-length v0, p3
    const/4 v1, 0x1
    if-ne v0, v1, :skip_add
    const/4 v0, 0x0
    aget v0, p3, v0
    invoke-static {p1, v0}, Lcom/sec/android/widgetapp/digitalclock/SharedManager;->addWidgetIds(Landroid/content/Context;I)V
    
    :skip_add
    invoke-static {p1, p2, p3}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->updateViews(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    return-void
.end method

.method public onDeleted(Landroid/content/Context;[I)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "appWidgetIds"    # [I
    
    .prologue
    invoke-super {p0, p1, p2}, Landroid/appwidget/AppWidgetProvider;->onDeleted(Landroid/content/Context;[I)V
    const/4 v0, 0x0
    aget v0, p2, v0
    invoke-static {p1, v0}, Lcom/sec/android/widgetapp/digitalclock/SharedManager;->removeWidgetIds(Landroid/content/Context;I)V
    return-void
.end method

.method public onEnabled(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    
    .prologue
    invoke-super {p0, p1}, Landroid/appwidget/AppWidgetProvider;->onEnabled(Landroid/content/Context;)V
    new-instance v0, Landroid/content/Intent;
    const-string v1, "digitalclock.action.startservice"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    invoke-virtual {p1, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    return-void
.end method

.method public onDisabled(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    
    .prologue
    invoke-super {p0, p1}, Landroid/appwidget/AppWidgetProvider;->onDisabled(Landroid/content/Context;)V
    new-instance v0, Landroid/content/Intent;
    const-string v1, "digitalclock.action.stopservice"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    invoke-virtual {p1, v0}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z
    invoke-static {p1}, Lcom/sec/android/widgetapp/digitalclock/SharedManager;->removeAllWidgetIds(Landroid/content/Context;)V
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;
    
    .prologue
    if-nez p2, :continue
    :end
    return-void
    
    :continue
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;
    move-result-object v0
    const-string v1, "sec.android.intent.action.HOME_RESUME"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :finish
    
    new-instance v1, Landroid/content/Intent;
    const-string v2, "digitalclock.action.startservice"
    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    invoke-virtual {p1, v1}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    
    :finish
    invoke-super {p0, p1, p2}, Landroid/appwidget/AppWidgetProvider;->onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    goto :end
.end method

.method public uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
    .locals 0
    .param p1, "arg0"    # Ljava/lang/Thread;
    .param p2, "arg1"    # Ljava/lang/Throwable;
    
    .prologue
    return-void
.end method
