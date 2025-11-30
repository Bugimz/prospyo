import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class GameInstructionsScreen extends StatelessWidget {
  const GameInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColor.mainWhiteColor,
          child: Padding(
            padding: ResponsiveUtils.pagePadding(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'آموزش بازی',
                      style: TextStyle(
                        fontFamily: 'iran',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.greenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          EvaIcons.homeOutline,
                          color: AppColor.textColor,
                        ),
                        onPressed: () => Get.offAllNamed('/home'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.04)),
                const Expanded(
                  child: ListView(
                    children: [
                      ExpansionTile(
                        backgroundColor: AppColor.greenColor,
                        title: Text(
                          'بازی جاسوس چیست؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'بازی جاسوس یک بازی گروهی مهیج است که در آن بازیکنان به دو تیم تقسیم می‌شوند: جاسوس‌ها و شهروندان. هدف اصلی این بازی برای تیم جاسوس‌ها این است که به هر نحوی که شده، اطلاعات تیم شهروندان را کشف کرده و کلمه ای که آنها دیده اند را بفهمند و بدانند آن کلمه در مورد چیست، در حالی که تیم شهروندان سعی دارند جاسوس‌ها را شناسایی کنند.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ExpansionTile(
                        backgroundColor: AppColor.redColor,
                        title: Text(
                          'چگونه بازی شروع می‌شود؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'توزیع نقش‌ها: ابتدا به هر بازیکن یک نقش اختصاص داده می‌شود. نقش‌ها می‌توانند شامل جاسوس، شهروند و در برخی نسخه‌ها نقش‌های ویژه مانند گشتاپو یا سلاخ باشند. انتخاب یک کلمه تصادفی: هر بازیکن یک کلمه خاص به عنوان هدف دریافت می‌کند. اما جاسوس‌ها نمی‌دانند این کلمه چیست و باید تلاش کنند تا از طریق حدس‌ها و سؤالات بازیگران دیگر، اطلاعات بیشتری به دست آورند.گام‌های بازی: هر دور بازی با طرح سؤالات شروع می‌شود و بازیکنان به نوبت سوال می‌پرسند و به سؤالات دیگران جواب می‌دهند. هدف این است که به تدریج هویت جاسوس‌ها مشخص شود.جاسوس‌ها در حال تلاش برای گمراه کردن: جاسوس‌ها باید در هنگام جواب دادن به سؤالات تلاش کنند که هویت خود را پنهان کرده و اطلاعات دروغین بدهند.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.blueColor,
                        title: Text(
                          'پایان بازی؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'بازی زمانی به پایان می‌رسد که یک تیم موفق به شناسایی تیم مقابل شود یا اینکه جاسوس‌ها موفق به دستیابی به اطلاعات مهم شوند یا شهروندان تک تک جاسوس ها را پیدا کرده و در رای گیری در پایان هر دور از بازی که نفر اولی است که سوالات را شروع کرده به او که برسد دور بازی تمام میشود و رای گیری میکنند اگر جاسوس بیرون رفت کلمه را حدس میزند اگر شهرند بود چیز خاصی نمیگوید و میگوید شهروند است جاسوس ها نباید  دروغ بگونید و دوباره بازی شروع میشود تا زمانی که یا کلمه را جاسوس ها بفهمند یا همه جاسوس ها بیرون باشند. ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.yellowColor,
                        title: Text(
                          'جاسوس کیه؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'جاسوس‌ها تلاش می‌کنند اطلاعات تیم شهروندان را کشف کنند و آن را به دست بیاورند.وظیفه: جاسوس‌ها نمی‌دانند کلمه اصلی چیست و باید از طریق سؤالات و جواب‌های بازیکنان دیگر اطلاعات به دست آورند. آن‌ها در تلاش‌اند تا هویت خود را مخفی نگه دارند و در عین حال به تیم خود کمک کنند تا کلمه را شناسایی کنند.ن‌ها باید به خوبی دروغ بگویند و سوالاتی مطرح کنند که بازیکنان دیگر شک نکنند.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.purpleColor,
                        title: Text(
                          'شهروند کیه؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'شناسایی جاسوس‌ها و محافظت از اطلاعات تیم خود.شهروندان باید با هوشیاری کامل جاسوس‌ها را شناسایی کنند و از آن‌ها بپرسند تا هویتشان را لو بدهند.ن‌ها کلمه اصلی را می‌دانند و باید با استدلال‌های منطقی و هوشمندانه به تیم خود کمک کنند تا جاسوس‌ها شناسایی شوند.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.greenColor,
                        title: Text(
                          'گشتاپو کیه؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'گشتاپو  نقش ویژه‌ای در بازی دارد.گشتاپو می‌تواند به تیم خود کمک کند و جاسوس‌ها را شناسایی کند. این نقش معمولاً اطلاعات اضافی در مورد دیگر بازیکنان یا کلمات را فاش می‌کند. چون دسته بندی کلمات را میتواند ببیند و میتواند بفهمد کلمه چیست و کمک بیشتری به تیم جاسوسی بکند',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.blueColor,
                        title: Text(
                          'سلاخ  کیه؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'در بعضی نسخ سلاخ وجود دارد. او می‌تواند در یک دور بازی همه جاسوس‌ها را شناسایی کند. در صورت موفقیت تیم شهروندان برنده می‌شود، در غیر این صورت تیم جاسوسان پیروز خواهد شد.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        backgroundColor: AppColor.yellowColor,
                        title: Text(
                          'نقش شهروند خائن؟',
                          style: TextStyle(
                            fontFamily: 'iran',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'شهروند خائن با جاسوس‌ها همراه است و می‌تواند به آنها کمک کند تا اطلاعات بیشتری به دست آورند. او کلمه اصلی را می‌داند و باید در زمان مناسب جاسوس‌ها را یاری دهد.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'iranLight',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
