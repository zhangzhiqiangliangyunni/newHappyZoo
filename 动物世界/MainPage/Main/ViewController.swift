//
//  ViewController.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/16.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import LeanCloud

class ViewController: UIViewController {
    
    //天上飞的，地上跑的，水里游的，土里爬的Tori
    enum SkyLandWaterTori:String{
        case sky = "sky"
        case land = "land"
        case water = "water"
        case tori = "tori"
    }
    
    enum sky:String{
        case skyContent1 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=0&spn=0&di=51480&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3327408968%2C3781282166&os=1740582552%2C3135723643&simid=3432481899%2C166230999&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F5%2F578c68062c02d.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Botg9aaa_z%26e3Bv54AzdH3F45ktsj_1jpwts_8ab9cl_n_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent2 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=1&spn=0&di=2970&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3578361224%2C3054701617&os=2409552623%2C4190711241&simid=3145033143%2C3772628771&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F4%2F54191767ccaf9.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-88b8n0a9_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent3 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=2&spn=0&di=71060&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2694491139%2C569805011&os=974500546%2C2747678721&simid=4243839366%2C565004120&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F49625bd29d116b6041b6597924ea094a912297713b96c-ywE1F9_fw658&fromurl=ippr_z2C%24qAzdH3FAzdH3Fi7wkwg_z%26e3Bv54AzdH3FrtgfAzdH3Fcmb8b9b8bAzdH3F&gsm=1&islist=&querylist="
        case skyContent4 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=3&spn=0&di=27610&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=443546865%2C3767595231&os=1882704009%2C2077801777&simid=3340613155%2C4281989227&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fa0.att.hudong.com%2F28%2F77%2F300001048486129103774010287_950.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fp7rtwg_z%26e3Bkwthj_z%26e3Bv54AzdH3FdanacAzdH3F80_z%26e3Bip4s%3Fr61%3Dz7p7_gjxp&gsm=1&islist=&querylist="
        case skyContent5 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=4&spn=0&di=58740&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2477360201%2C4232561269&os=809188801%2C3780832286&simid=3452256724%2C275118201&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fahjdjx.cn%2Fimg.php%3Fpic1a.nipic.com%2F20090326%2F_165413002_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fwi313x_z%26e3BvgAzdH3F%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25AB_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent6 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=5&spn=0&di=20570&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1018910430%2C704499341&os=1048661247%2C2940339199&simid=3514582062%2C379243472&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201511%2F30%2F20151130190413_GHZkr.thumb.700_0.jpeg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-88b8n0a9_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent7 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=6&spn=0&di=79420&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2322660314%2C819592314&os=3836723480%2C1521182475&simid=3419731405%2C214922902&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.ph.126.net%2FsSUlEnUfeTHlpFgVLwuSLQ%3D%3D%2F1301540292326860230.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-9bbcmnn_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent8 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=7&spn=0&di=106480&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2924447078%2C3835645587&os=2669281892%2C653598049&simid=3366648169%2C289460915&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F1%2F57835f6acc8e7.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-88b8n0a9_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent9 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=11&spn=0&di=80300&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3777824289%2C925624392&os=1681463092%2C2991254227&simid=4210710544%2C928607535&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fd%2F54782945e7447.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Botg9aaa_z%26e3Bv54AzdH3Fowssrwrj6_kt2_c0ddn_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent10 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=12&spn=0&di=78100&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3137117694%2C2256271635&os=261606092%2C1471121663&simid=4214794218%2C695035224&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fwww.gardenson.cn%2Fimg.php%3Fimg02.tooopen.com%2Fimages%2F20150611%2Ftooopen_sy_129833058574.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B2w61jgf5g_z%26e3BvgAzdH3F%25E0%25l9%25AF%25Em%25AD%25bC%25EE%25lD%25bm%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25AB%25Em%25BE%25Bm%25D8%25bn%25Ec%25bF%25bF%25Em%25Ac%25Am%25E0%25bm%25B0%25Em%25bd%25lc_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent11 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=13&spn=0&di=28270&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3036101493%2C2072119380&os=2450966047%2C3547251899&simid=4093964873%2C672275895&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.nipic.com%2F2008-08-20%2F2008820144527412_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3F8AzdH3F9aAzdH3F9nkblacd0kju00wl_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent12 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=14&spn=0&di=35310&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3171802405%2C3485275116&os=1678134438%2C4023781708&simid=1807874%2C902089162&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fphotoblog%2F1607%2F05%2Fc15%2F23804132_1467732379423_mthumb.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-b9n98na_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent13 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=15&spn=0&di=44880&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1716283019%2C1871629698&os=3375043422%2C3831548567&simid=3498260527%2C457123350&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fwww.huiyuanjiaxiao.cn%2Fimg.php%3Fp0.so.qhimgs1.com%2Ft019796a7bac481441a.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bi7ty7wg3twxtw5_z%26e3BvgAzdH3F%25El%25bD%25lA%25Ec%25bB%25AD%25EE%25lD%25ld%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25AB%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm%25El%25bD%25lA%25Ec%25Bm%25bc%25E0%25ln%25A0%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent14 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=16&spn=0&di=118140&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1495630292%2C2380494646&os=4051148409%2C1743241947&simid=4051750397%2C552936096&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fbizhiwa.com%2Fuploads%2Fallimg%2F2012-03%2F15160927-1-93624.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B4wsj451jsfrtvp76j_z%26e3BgjpAzdH3F%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25AB%25El%25lm%25Bd%25Ec%25BA%25An%25Em%25lc%25ln%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lmAzdH3F%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25AB%25El%25lm%25Bd%25Ec%25BA%25An%25Em%25lc%25ln%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent15 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=18&spn=0&di=78210&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1599470199%2C2675146620&os=3380991720%2C4220835392&simid=4180493747%2C896556931&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fe%2F543f61fc38c1c.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B8yhj_z%26e3BvgAzdH3F%25E0%25ld%25bB%25E9%25BD%25Bl%25Em%25Bb%25Bm%25Em%25Bc%25lC%25Ec%25l0%25lA%25Da%25ld%25Em%25Ac%25Am%25E0%25bm%25BA%25Eb%25Ad%25ABAzdH3F&gsm=1&islist=&querylist="
        case skyContent16 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=19&spn=0&di=10670&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3543023329%2C3842698983&os=345360826%2C3662865959&simid=4079461423%2C585106929&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Ftpic.home.news.cn%2FxhForum%2Fxhdisk002%2FM00%2F0E%2F82%2FwKhJC1UX2EUEAAAAAAAAAAAAAAA907.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fkt2c_z%26e3Bxtgi7wgjp_z%26e3Bv54AzdH3F2wpjAzdH3Fkt2cAzdH3Fu5674_z%26e3Bi54j_z%26e3Bgjof_z%26e3BvgAzdH3Fr5fpAzdH3FetjoP5fp_z%26e3B15%3Fej6%3D8%26t1%3D8nc88ca9c%26r2%3D8d&gsm=1&islist=&querylist="
        case skyContent17 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=20&spn=0&di=103730&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2879617602%2C3403823881&os=109437609%2C133972859&simid=3551229192%2C592173026&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic40.nipic.com%2F20140329%2F2531170_083254626000_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B4wsj451jsfrtvp76j_z%26e3BgjpAzdH3F%25Em%25Ac%25An%25EF%25Bl%25bd%25E0%25AE%25lF%25E0%25BC%25b0%25Eb%25bA%25Ac%25E0%25lb%25BA%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lmAzdH3F%25Em%25Ac%25An%25EF%25Bl%25bd%25E0%25AE%25lF%25E0%25BC%25b0%25Eb%25bA%25Ac%25E0%25lb%25BA%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm-%25Em%25Ac%25bd%25Em%25Ab%25BB%25E0%25AB%25BB%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm3r2%25El%25bF%25bD%25E0%25bc%25bE%25E0%25B9%25A8_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent18 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=21&spn=0&di=137390&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3910127121%2C121609294&os=2488160445%2C1226312308&simid=18159231%2C647740697&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fphotoblog%2F1103%2F21%2Fc1%2F7061581_7061581_1300663914437.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-d8nclcmm_z%26e3Bip4s&gsm=3c&islist=&querylist="
        case skyContent19 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=22&spn=0&di=22550&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3758432564%2C3151733647&os=557325655%2C463169535&simid=3300990680%2C3870698962&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fphotoblog%2F1601%2F20%2Fc1%2F17732611_1453231759429_mthumb.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fp7fi727wg_z%26e3Bp7xt_z%26e3Bv54_z%26e3BvgAzdH3F80-a98m-8l-8aald9m8uqzm9maln90b_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent20 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=23&spn=0&di=23210&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=114774133%2C4270441739&os=2728444498%2C273342547&simid=3371524679%2C46895413&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fwww.775jia.net%2Fhuoli%2Fuploadfiles_7852%2F201110%2F2011102415150931.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bnma15v_z%26e3Bv54AzdH3Fv5gpjgpAzdH3F8cAzdH3Fab8cAzdH3FdaAzdH3Fldab099_9l8bc0dnc_z%26e3Bfip4s&gsm=1&islist=&querylist="
        case skyContent21 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=24&spn=0&di=78760&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=154338838%2C1789149079&os=14193460%2C472157799&simid=3483050945%2C307971497&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F201511%2F30%2F20151130192053_uAUZk.jpeg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B17tpwg2_z%26e3Bv54AzdH3Fks52AzdH3F%3Ft1%3D9ll0alb8m&gsm=1&islist=&querylist="
        case skyContent22 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=25&spn=0&di=23430&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2788021618%2C1533421800&os=354229541%2C312338551&simid=3483259398%2C548010466&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F4e4a20a4462309f77dadd159740e0cf3d6cad6bf.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bp7xt_z%26e3Bv54_z%26e3BvgAzdH3Fetjok-8n0dbadlamcn0mm-8n0dbadlamcn0mm08nl_z%26e3Bip4s&gsm=1&islist=&querylist="
        case skyContent23 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=26&spn=0&di=99330&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2596833196%2C2063932031&os=4274522044%2C55413892&simid=4175092028%2C481618939&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic31.nipic.com%2F20130712%2F6755670_150420124123_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3B8yhj_z%26e3BvgAzdH3F%25Ec%25Ba%25bF%25El%25Bb%25lF%25E0%25lA%25b9%25Ec%25lB%25BE%25E0%25bl%25b0AzdH3F&gsm=1&islist=&querylist="
        case skyContent24 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=36&spn=0&di=6270&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3400608865%2C480637276&os=1004076671%2C3845757021&simid=3318308751%2C114005617&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F4a36acaf2edda3cc68a5d1c909e93901203f9291.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3F1s_z%26e3Bx7jmn_z%26e3Bv54AzdH3F3tw5y7x7jxtkwAzdH3Fz75ojgAzdH3Ffi754tg2ojgAzdH3Fdaacm8d_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent25 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=37&spn=0&di=107910&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3143781197%2C655485368&os=1849791236%2C3031193042&simid=3365972114%2C213887593&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F8%2F573fd052d8164.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Botg9aaa_z%26e3Bv54AzdH3Fowssrwrj6_kt2_8a9b8c_m_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent26 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=41&spn=0&di=143660&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2018787859%2C1011199457&os=355356420%2C2623255070&simid=3459554347%2C173043472&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Ffile3.foodmate.net%2Fattachment%2Fforum%2Fmonth_0806%2F20080626_ad0fc95abd611a27a0d7asb1cz8vraez.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fkkf_z%26e3Bu5514wpj_z%26e3BgjpAzdH3Fpi6jw1-8l909d-8-8_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent27 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=42&spn=0&di=73920&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=178454227%2C1330240940&os=2381260349%2C401953851&simid=4136565954%2C624116482&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fitbbs%2F1401%2F05%2Fc22%2F30314218_1388929168787_mthumb.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3F1r_z%26e3Brv5gstgj_z%26e3Bv54_z%26e3BvgAzdH3F1ri5p5AzdH3Fnd9a0dm_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent28 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=44&spn=0&di=7700&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3254601012%2C2036653352&os=3188209876%2C2696559855&simid=3441892928%2C486802486&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1204%2F25%2Fc1%2F11371066_1335334760615_800x800.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bu6jjr_z%26e3BvgAzdH3Fp57ptw5AzdH3Fna00dmm_z%26e3Bip4&gsm=1e&islist=&querylist="
        case skyContent29 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=48&spn=0&di=92620&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1787322153%2C542216596&os=389836737%2C3218045005&simid=3496976123%2C227317437&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fs2.sinaimg.cn%2Fmw690%2Fc09e68c8tdbb8a95c3f81%26690&fromurl=ippr_z2C%24qAzdH3FAzdH3Fxtw5x7j_z%26e3Bp7xt_z%26e3Bv54_z%26e3BvgAzdH3Fetjok-8n0d00ladmcb80b-8n0d00ladmcb80bacnl_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent30 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=49&spn=0&di=7370&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1387551134%2C342453574&os=3651739663%2C2166048545&simid=3390089261%2C201928782&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg0.ph.126.net%2FgOSvGqN0mbJpfdVAtuZCPw%3D%3D%2F1446781380393390132.png&fromurl=ippr_z2C%24qAzdH3FAzdH3Fg23bc8_z%26e3Bks52_z%26e3B8mn_z%26e3Bv54AzdH3Fks52AzdH3FfpwptvAzdH3F8d0d8m8nmda89c889ldb8cdAzdH3F%3Ff722jfpj16jw1tg2%26o74tt&gsm=1e&islist=&querylist="
        case skyContent31 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=57&spn=0&di=32890&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1044147328%2C3004155141&os=1028368997%2C3230750974&simid=3434210387%2C349527299&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F9%2F58aa856448b26.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Botg9aaa_z%26e3Bv54AzdH3Fowssrwrj6_kt2_8ddd8l_0_z%26e3Bip4s&gsm=1e&islist=&querylist="
        case skyContent32 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=62&spn=0&di=6710&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3307370400%2C2909695328&os=4005492693%2C2379195741&simid=3449128766%2C367489414&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fphotoblog%2F1607%2F14%2Fc13%2F24190562_1468506267530.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bxtvt_z%26e3BgjpAzdH3FtvijAzdH3F14w-b9n98na_z%26e3Bip4s&gsm=3c&islist=&querylist="
        case skyContent33 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=74&spn=0&di=107470&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=2113061816%2C1028433023&os=3542229063%2C2414073337&simid=3309638967%2C194629302&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fimg8.zol.com.cn%2Fbbs%2Fupload%2F17778%2F17777585.gif&fromurl=ippr_z2C%24qAzdH3FAzdH3F1vkkf_z%26e3Bz5s_z%26e3Bv54_z%26e3BvgAzdH3F8AzdH3Fn9adl_8an_z%26e3Bip4s&gsm=3c&islist=&querylist="
        case skyContent34 = "https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=鸟类高清图片&hs=2&pn=76&spn=0&di=61160&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=4011563365%2C3922832007&os=3206616178%2C3296677617&simid=4258087609%2C742270292&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=鸟类高清图片&objurl=http%3A%2F%2Fpic.birdnet.cn%2Fforum%2F201902%2F04%2F074122ui0m7m3i0mz1wr5m.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bvitgwz5y5_z%26e3Bv54_z%26e3BvgAzdH3F%25Em%25Bc%25Aa%25Em%25AC%25ln%25Ec%25B0%25Ac%25El%25bD%25Ac%25Ec%25bl%25A0%25Ec%25Ad%25lm%25Em%25BE%25Bl%25E9%25BD%25BA%25E0%25b9%25bAAzdH3F&gsm=3c&islist=&querylist="
    }
    
    enum ZooType: String {
        case animal = "animal"
        case plant = "plant"
        case car = "car"
        case pictureView = "pictureView"
        case other = "other"
        case family = "family"
    }

    struct Animals {
        var sky: sky.RawValue
        var water: String
        var land: String
        var tori: String
        
        init(Sky: sky.RawValue, Water: String, Land:String, Tori: String) {
            self.sky = Sky
            self.water = Water
            self.land = Land
            self.tori = Tori
        }
    }
    
    var imgsSourceDic: [String:String] = [:]
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var AreaIcon1: UIView!
    @IBOutlet weak var AreaIcon2: UIView!
    @IBOutlet weak var AreaIcon3: UIView!
    @IBOutlet weak var AreaIcon4: UIView!
    @IBOutlet weak var AreaIcon5: UIView!
    @IBOutlet weak var AreaIcon6: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sound.preparedAllSounds()
        setupUI()   
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return UIInterfaceOrientationMask.landscape
        }
        return .portrait
    }
    
    
    //初始化UI
    func setupUI(){

        bgView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let tap1 = UITapGestureRecognizer()
        tap1.addTarget(self, action: #selector(tap1Action))
        AreaIcon1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer()
        tap2.addTarget(self, action: #selector(tap2Action))
        AreaIcon2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer()
        tap3.addTarget(self, action: #selector(tap3Action))
        AreaIcon3.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer()
        tap4.addTarget(self, action: #selector(tap4Action))
        AreaIcon4.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer()
        tap5.addTarget(self, action: #selector(tap5Action))
        AreaIcon5.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer()
        tap6.addTarget(self, action: #selector(tap6Action))
        AreaIcon6.addGestureRecognizer(tap6)
        
        //添加评论提交入口控件
        addReviewSubmitView()
    }
    
    func addReviewSubmitView() {
        let reviewSubmitView = ReviewSubmitView(frame: CGRect(x: self.view.bounds.maxX - 100, y: 50, width: 60, height: 60))
        self.view.addSubview(reviewSubmitView)
    }

    @objc func tap1Action(){
        AreaIcon1.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {[weak self] in
                        guard let `self` = self else { return }
                        self.AreaIcon1.transform = CGAffineTransform.identity
        },
                       completion: {[weak self] Void in()
                        guard let `self` = self else { return }
                        let num1VC = Num1ViewController()
                        num1VC.view.frame = self.view.bounds
                        num1VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num1VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num1VC = num1VC

                        UIView.animate(withDuration: 0.5) {
                            num1VC.view.frame.origin.x = 0
                        }

        })
        
    }
    
    @objc func tap2Action(){
        AreaIcon2.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.AreaIcon2.transform = CGAffineTransform.identity
        },
                       completion: { Void in()

                        let num2VC = Num2ViewController()
                        num2VC.view.frame = self.view.bounds
                        num2VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num2VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num2VC = num2VC

                        UIView.animate(withDuration: 0.5) {
                            num2VC.view.frame.origin.x = 0
                        }

                        num2VC.closeNum2 { [weak self] in
                            num2VC.view.frame.origin.x = self?.view.bounds.width ?? 0
                        }
        }
        )

    }
//
    @objc func tap3Action(){
        AreaIcon3.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.AreaIcon3.transform = CGAffineTransform.identity
        },
                       completion: { Void in()

                        let num3VC = Num3ViewController()
                        num3VC.view.frame = self.view.bounds
                        num3VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num3VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num3VC = num3VC

                        UIView.animate(withDuration: 0.5) {
                            num3VC.view.frame.origin.x = 0
                        }

                        num3VC.closeNum3 { [weak self] in
                            num3VC.view.frame.origin.x = self?.view.bounds.width ?? 0
                        }

        }
        )

    }
//
    @objc func tap4Action(){
        AreaIcon4.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.AreaIcon4.transform = CGAffineTransform.identity
        },
                       completion: { Void in()

                        let num4VC = Num4ViewController()
                        num4VC.view.frame = self.view.bounds
                        num4VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num4VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num4VC = num4VC

                        UIView.animate(withDuration: 0.5) {
                            num4VC.view.frame.origin.x = 0
                        }

                        num4VC.closeNum4 { [weak self] in
                            num4VC.view.frame.origin.x = self?.view.bounds.width ?? 0
                        }
        }
        )

    }
//
    @objc func tap5Action(){
        AreaIcon5.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.AreaIcon5.transform = CGAffineTransform.identity
        },
                       completion: { Void in()

                        let num5VC = Num5ViewController()
                        num5VC.view.frame = self.view.bounds
                        num5VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num5VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num5VC = num5VC

                        UIView.animate(withDuration: 0.5) {
                            num5VC.view.frame.origin.x = 0
                        }

                        num5VC.closeNum5 { [weak self] in
                            num5VC.view.frame.origin.x = self?.view.bounds.width ?? 0
                        }

        }
        )

    }
//
    @objc func tap6Action(){
        AreaIcon6.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: { [weak self] in
                        self?.AreaIcon6.transform = CGAffineTransform.identity
        },
                       completion: { Void in()

                        let num6VC = Num6ViewController()
                        num6VC.view.frame = self.view.bounds
                        num6VC.view.frame.origin.x = self.view.bounds.width
                        let window = UIApplication.shared.windows[0]
                        window.addSubview(num6VC.view)
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.num6VC = num6VC

                        UIView.animate(withDuration: 0.5) {
                            num6VC.view.frame.origin.x = 0
                        }
        })

    }
  
}



