/*
Copyright (c) 2012, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/

/**
 * <p>
 * The Date utility provides convenience methods for dealing with date formats.
 * </p>
 * <p>
 * This module requires the KD.utils.Util and YAHOO.util.DataSource modules.
 * </p>
 *
 * @module date
 * @requires KD.utils.Util, YAHOO.util.Datasource
 */

(function () {
    /**
     * The Date class provides helper functions to deal with data of
     * type Date.
     *
     * @namespace KD.utils
     * @class Date
     * @static
     */
    KD.utils.Date = {
        /**
         * Retrieves the user's Locale value from their local workstation
         *
         * @method getLocale
         * @return {String} locale value such as en, en-AU, en-US, etc...
         */
        getLocale: function () {
            return KD.utils.Util.getLocale();
        },

        /**
         * Gets the Date string formatted to the users locale
         *
         * @method getLocaleDateString
         * @param {String} dateStr A date string value such as '06/02/2010 14:17:53'
         * @return {String} a locale formatted date string
         */
        getLocaleDateString : function (dateStr) {
            var dt = new Date(Date.parse(dateStr));
            return YAHOO.util.Date.format(dt, {format:"%x"}, this.getLocale());
        },

        /**
         * Gets the Date/Time string formatted to the users locale
         *
         * @method getLocaleDatetimeString
         * @param {String} dateStr A date string value such as '06/30/2010 14:17:53'
         * @return {String} a locale formatted date and time string
         */
        getLocaleDatetimeString : function (dateStr) {
            var locale = this.getLocale(),
                dt = new Date(Date.parse(dateStr));

            locale = locale.substring(0,2) + locale.substring(2,5).toUpperCase();
            // locale='en-US';

            return YAHOO.util.Date.format(dt, {format:"%x"}, locale) + ' ' +
                YAHOO.util.Date.format(dt, {format:"%X"}, locale);
        }

    };

})();