﻿using PGMEATS_WEB.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Mvc;


namespace PGMEATS_WEB.Controllers
{
    [SessionExpire]
    public class MenuController : Controller
    {
        // GET: Menu
        public ActionResult SideMenu()
        {
            string userID = "";
            try
            {
                if (Session["LogUserID"] != null)
                {
                    userID = Session["LogUserID"].ToString();

                    List<clsMenu> MenuDat = new List<clsMenu>();
                    clsMenuDB MenuDB = new clsMenuDB();
                    MenuDat = MenuDB.MenuList().ToList();
                    return PartialView("_Aside", MenuDat);
                }
                else
                {
                    return RedirectToAction("Home", "Login");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}