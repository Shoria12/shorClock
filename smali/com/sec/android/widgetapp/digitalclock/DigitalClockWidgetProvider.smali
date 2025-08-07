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

.method private static drawClock(Landroid/content/Context;Landroid/widget/RemoteViews;Ljava/util/Date;)V
    .locals 6
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "views"    # Landroid/widget/RemoteViews;
    .param p2, "date"    # Ljava/util/Date;
    
    .prologue
    # Получаем часы и минуты
    invoke-virtual {p2}, Ljava/util/Date;->getHours()I
    move-result v1
    invoke-virtual {p2}, Ljava/util/Date;->getMinutes()I
    move-result v2
    
    # Создаем StringBuilder для времени
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    
    # Добавляем часы (с ведущим нулем)
    const/16 v3, 0xa
    if-ge v1, v3, :hour_ok
    const-string v4, "0"
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :hour_ok
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Добавляем двоеточие
    const-string v4, ":"
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    
    # Добавляем минуты (с ведущим нулем)
    if-ge v2, v3, :min_ok
    const-string v4, "0"
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :min_ok
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    
    # Устанавливаем время в TextView (используем ID clock_hour01)
    const v3, 0x7f070002  # Попробуй разные ID: 0x7f070001, 0x7f070002, 0x7f070003
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {p1, v3, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V
    
    return-void
.end method

.method private static hideElements(Landroid/widget/RemoteViews;)V
    .locals 2
    .param p0, "views"    # Landroid/widget/RemoteViews;
    
    .prologue
    const/4 v1, 0x4  # INVISIBLE
    
    # Скрываем AM/PM
    const v0, 0x7f070007
    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V
    
    # Скрываем дату
    const v0, 0x7f07000b
    invoke-virtual {p0, v0, v1}, Landroid/widget/RemoteViews;->setViewVisibility(II)V
    
    return-void
.end method

.method private static updateViews(Landroid/content/Context;Landroid/appwidget/AppWidgetManager;[I)V
    .locals 6
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "aw"    # Landroid/appwidget/AppWidgetManager;
    .param p2, "widgetIds"    # [I
    
    .prologue
    # Создаем RemoteViews
    new-instance v3, Landroid/widget/RemoteViews;
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v4
    const/high16 v5, 0x7f030000
    invoke-direct {v3, v4, v5}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V
    
    # Текущее время
    new-instance v0, Ljava/util/Date;
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v4
    invoke-direct {v0, v4, v5}, Ljava/util/Date;-><init>(J)V
    
    # Скрываем ненужные элементы
    invoke-static {v3}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->hideElements(Landroid/widget/RemoteViews;)V
    
    # Рисуем часы
    invoke-static {p0, v3, v0}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->drawClock(Landroid/content/Context;Landroid/widget/RemoteViews;Ljava/util/Date;)V
    
    # Обновляем виджет
    invoke-static {p1, p2, v3}, Lcom/sec/android/widgetapp/digitalclock/DigitalClockWidgetProvider;->updateWidget(Landroid/appwidget/AppWidgetManager;[ILandroid/widget/RemoteViews;)V
    
    return-void
.end method

.method private static updateWidget(Landroid/appwidget/AppWidgetManager;[ILandroid/widget/RemoteViews;)V
    .locals 2
    .param p0, "aw"    # Landroid/appwidget/AppWidgetManager;
    .param p1, "widgetIds"    # [I
    .param p2, "views"    # Landroid/widget/RemoteViews;
    
    .prologue
    if-eqz p0, :end
    if-nez p1, :end
    
    const/4 v0, 0x0
    :loop
    array-length v1, p1
    if-ge v0, v1, :end
    aget v1, p1, v0
    invoke-virtual {p0, v1, p2}, Landroid/appwidget/AppWidgetManager;->updateAppWidget(ILandroid/widget/RemoteViews;)V
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